<?php
/**
 * Database documentation (deduced from code and DDL where noted).
 * All content below is in comments so it is not executed or output.
 * Sections: (1) application DB — pieteikums and related tables;
 *           (2) accounting DBs on a separate server — yearly sXXXX, kopiga;
 *           (3) date input convention — dd.mm.yyyy and Db::sql_date.
 */

/*
================================================================================
DATE INPUT (web forms → yyyy-mm-dd)
================================================================================
Users enter calendar dates as dd.mm.yyyy (Latvian style). Convert to yyyy-mm-dd
for validation, SQL parameters, and DateTime: Db::sql_date($string, 'd.m.Y') in
online2/m_init_utf.php — normalizes single-digit day and month before parsing.

Used for gift-card invoice payment date: c_davanu_kartes_rekins.php (field
last_payment_datums) and c_davanu_kartes_rekins_generet.php before Rekini insert.

================================================================================
TABLE: pieteikums
================================================================================
Application/booking record: one row per participant per trip (grup) within an
online or offline reservation. Used for travel reservations, gift cards, etc.

Relationships (FKs deduced from code):
  - did         -> dalibn.ID        (participant / dalībnieks)
  - online_rez  -> online_rez.id    (online reservation header; NULL = offline)
  - gid        -> grupa.id         (trip/tour group)

Child table:
  - piet_saite.pid -> pieteikums.id  (detail lines: services, room types, cabins)

Referenced by:
  - orderis.pid -> pieteikums.id     (payments/orders)

--------------------------------------------------------------------------------
Fields (deduced from m_pieteikums.php, m_init_utf.php, and usage in code)
--------------------------------------------------------------------------------

id              PK. Identity.
datums          Creation date/time. Set on Insert (Y-m-d H:i:s, Europe/Riga).
vesture         History log (HTML text): who did what, when; appended on updates.
deleted         Soft delete: 0 = active, 1 = deleted.
agents          Agent-related flag; default 0 on Insert.
personas        Number of persons for this application; default 1.
atcelts         Cancelled: 0 = active, 1 = cancelled.
izveidoja       Who created: e.g. 'online' or user identifier.
internets       Source: 1 = online, 0 = other; used for Insert max_id_param.
step            Workflow/step flag; default 0 on Insert.
is_new          New-record flag; default 1 on Insert.

did             FK -> dalibn.ID. Participant (dalībnieks) for this application.
online_rez      FK -> online_rez.id. Online reservation; NULL if offline.
gid            FK -> grupa.id. Trip/tour group. Filtered by invisibleGid in code.

summaEUR        Total amount EUR (for pieteikums).
summaLVL        Total amount LVL.
summaUSD        Total amount USD.
atlaidesEUR     Discount EUR.
atlaidesLVL     Discount LVL.
sadardzinEUR    Surcharge EUR (sadārdzinājums).
sadardzinLVL    Surcharge LVL.
iemaksasEUR     Total payments in EUR.
izmaksasEUR     Total refunds/payouts EUR.
iemaksasLVL     Total payments LVL.
izmaksasLVL     Total refunds LVL.
bilanceEUR      Balance EUR (e.g. for gift cards).

papildvietas    Flag: has extra places (papildvietas); set from piet_saite.
tmp             Temporary/confirmed: 0 = confirmed; used with agents_izv.
vieta_rezerveta_lidz   Place reserved until (datetime).
dat_atcelts     Cancellation date (when atcelts=1).
old_gid         Previous grupa id (if changed).
ligums_id       Contract (līgums) ID.
carter_voucer   Voucher printed flag.

Gift card (dāvanu karte) fields:
dk_numurs       Gift card number.
dk_kods         Gift card code.
dk_serija       Gift card series.
dk_kam          Gift card "to whom" / recipient.
dk_summa        Gift card amount.
sakuma_datums   Start date (for gift card validity).

profile_id      Optional; link to profili (used in some queries e.g. GetDalibnList).

--------------------------------------------------------------------------------
Stored procedures (from code)
--------------------------------------------------------------------------------
- pieteikums_calculate_jauns @pid  (recalculates pieteikums)
- pieteikums_calculate           (legacy; also calls PieteikumsCalculate in PHP)

--------------------------------------------------------------------------------
Index / filter used in code
--------------------------------------------------------------------------------
- invisibleGid (e.g. 458): grupas not shown to client (e.g. "Atteikušies").
- Queries often: ... AND p.deleted = 0 AND p.gid NOT IN (invisibleGid).

================================================================================
RELATED TABLE: piet_saite
================================================================================
Detail lines for pieteikums: each row = one service/place type (e.g. base price,
hotel supplement, cabin, extra place). Many piet_saite rows per one pieteikums.

Relationships:
  pid            -> pieteikums.id
  did            -> dalibn.ID       (participant for this line; can differ from pieteikums.did in some cases)
  vid            -> viesnicas.id     (hotel room; 0 or NULL = not assigned)
  kid            -> kajite.id       (cabin; 0 or NULL = not assigned)
  vietas_veids   -> vietu_veidi.id  (place/price type)

--------------------------------------------------------------------------------
Fields (from GetPietSaiteEditFields, GetSaiteId, InsertSaite, i_pieteikums_calculate, PlaceInRoom, m_grupa, m_ligumi)
--------------------------------------------------------------------------------
  id               PK.
  pid              FK -> pieteikums.id.
  did              FK -> dalibn.ID. Participant for this line.
  vietsk           Place count (vietu skaits). Default 1 on InsertSaite. Used in sum: (cena + ...)*vietsk.
  deleted          Soft delete: 0 = active, 1 = deleted.
  persona          Whether line counts as a person (1) or not (0). Default 0 on InsertSaite. From vietu_veidi.persona or cabin logic (kid + kvietas_veids).
  papildv          Extra-place flag (papildvieta): 1 = papildvieta, 0 = no. Used in GetPapildvId (sum vietsk where papildv=1) and grupa papildvietas query.

  vietas_veids     FK -> vietu_veidi.id. Place/price type (base C/CH1, hotel VV/V1, papildvieta P, etc.). Can be set to 0 when clearing.
  vid              FK -> viesnicas.id. Assigned hotel room; 0 or NULL = not assigned.
  kid              FK -> kajite.id. Assigned cabin; 0 or NULL = not assigned.
  kvietas_veids    Cabin place type (kajītes vietas veids). Values 3,6,7 = special (e.g. child); used in persona and kajite logic.

  vietas_cena      Place unit price (base currency).
  vietas_cenaLVL   Place unit price LVL.
  vietas_cenaEUR   Place unit price EUR.
  vietas_cenaUSD   Place unit price USD.
  kvietas_cena     Cabin place unit price.
  kvietas_cenaLVL  Cabin place unit price LVL.
  kvietas_cenaEUR  Cabin place unit price EUR.
  kvietas_cenaUSD  Cabin place unit price USD.
  cena             Price correction / base rate (per unit). Used in sum: (vietas_cena + kvietas_cena + cena) * vietsk.
  cenaLVL, cenaEUR, cenaUSD   Same per currency.

  summa            Line total (base currency).
  summaLVL         Line total LVL. Aggregated in pieteikums_calculate from piet_saite.
  summaEUR         Line total EUR.
  summaUSD         Line total USD.

History (GetPietSaiteEditFields): changes to vietsk, vietas_veids, vid, kid, kvietas_veids, summaEUR, summa are logged in pieteikums.vesture.

InsertSaite defaults: vietsk=1, deleted=0, persona=0, papildv=0. Typical passed keys: pid, did, vietas_veids, (vid, kid, kvietas_veids), summaEUR.

Business logic (from code):
- PlaceInRoom: assigns hotel (vid) and base vietas_veids to one saite; can insert a second row for viesnicas supplement (vietu_veidi_id from viesnicas_veidi). Hotel supplement lines (vietu_veidi.tips VV/V1) are soft-deleted first.
- DeleteSaite: soft-delete (deleted=1) lines where vid=0 or NULL and kid=0 or NULL; for lines with vid/kid, only vietas_veids is set to 0.
- UpdatePietPapildv: sets pieteikums.papildvietas = 1 if any piet_saite has papildv=1 and deleted=0 for that pid.
- pieteikums_calculate aggregates sum(summaLVL), sum(summaEUR), sum(summaUSD) from piet_saite (deleted=0) into pieteikums.
- vietu_veidi.tips: C/CH1 = base, VV/V1 = hotel supplement, P = papildvieta, G = excluded from participant counts.

================================================================================
RELATED TABLE: online_rez
================================================================================
Online reservation header. One row per reservation session; multiple pieteikums
rows can belong to one online_rez (one per participant/trip combination). Used for
travel reservations and gift-card (dāvanu karte) purchases.

Relationships:
  profile_id  -> profili.id   (owner of the reservation; 0 for unregistered gift-card)
  ligums_id   -> ligumi.id    (contract when created; set by m_ligumi)

--------------------------------------------------------------------------------
Fields (from m_online_rez.php, Insert, Delete, Accept, UpdateComment, ExtendTime,
merchant_2, m_ligumi, c_reservation, bank scripts)
--------------------------------------------------------------------------------
  id                    PK. Returned by Insert as MAX(id) for same profile_id.
  profile_id            FK -> profili.id. Reservation owner. 0 for guest gift-card.
  datums                Creation date/time. Set on Insert (Y-m-d H:i:s, Europe/Riga).
  deleted               Soft delete: 0 = active, 1 = deleted.
  closed                Flag; default 0 on Insert.
  deriga_lidz           Valid until (datetime). Reservation must be completed before this; ExtendTime() adds minutes.
  no_delete             If 1, reservation is protected from auto-delete (e.g. after payment started/succeeded). Set by merchant_2, get_citadele, gift-card payment.
  tika_lidz_bankai      Set to 1 when user reached bank (payment flow). On Delete, used to set epasts_dzesta_neapmaksata for email about deleted unpaid reservation.
  epasts_dzesta_neapmaksata   Set on Delete: 1 if tika_lidz_bankai was 1 (so email can be sent about deleted unpaid reservation), else 0.
  dk_attelota           Gift card “attēlota” (used/displayed). Set to 1 with no_delete when gift-card payment is done (c_reservation).
  apstiprinata          Accept() sets to 1 (reservation confirmed).
  komentars             Comment text; set via UpdateComment().
  ligums_id             FK -> ligumi.id. Set when contract is created (m_ligumi Insert/UpdateWhere).
  conversion            Analytics: set to 1 when conversion completed (c_reservation).
  invoice_status        Invoice status for the reservation: 'requested' (invoice requested), 'sent' (invoice created/sent), or NULL (no invoice yet).

Insert(profile_id, deriga_min): sets profile_id, datums, deleted=0, closed=0, deriga_lidz = now + deriga_min minutes. Gift-card flow uses deriga_min=1440, profile_id can be 0.
GetId(id): SELECT * WHERE id=? AND deleted=0.
Delete(id): only if no_delete=0; sets deleted=1, epasts_dzesta_neapmaksata; then UPDATE pieteikums SET deleted=1 WHERE online_rez=? and UPDATE piet_saite SET deleted=1 WHERE pid IN (SELECT id FROM pieteikums WHERE online_rez=?).

Business logic:
- GetNeapmaksatas(): unpaid reservations with no_delete=1 and no orderis; uses tika_lidz_bankai, ligums_id.
- Gift-card reservations: pieteikums.online_rez IN (SELECT id FROM online_rez WHERE no_delete=1); GetDkWhere joins orez.no_delete, orez.dk_attelota.
- CanEdit(id): false if contract accepted or HasPayment; else true.

Relationship: pieteikums.online_rez -> online_rez.id.

================================================================================
RELATED TABLE: dalibn
================================================================================
Participants/members (dalībnieki). Person data: vards, uzvards, pk1, pk2,
nosaukums, novads, eadr, etc. Linked to profili via pk1, pk2.

Relationship: pieteikums.did -> dalibn.ID. Also piet_saite.did -> dalibn.ID.

================================================================================
RELATED TABLE: grupa
================================================================================
Trip/tour group. One row per departure/group of a trip. Links to marsruts (route).

Fields (from code): id, kods, mID (-> marsruts.id), valuta, atcelta,
sapulces_dat, sapulces_laiks_no, sapulces_laiks_lidz, etc.

Relationship: pieteikums.gid -> grupa.id. grupa.mID -> marsruts.id.

================================================================================
RELATED TABLE: vietu_veidi
================================================================================
Place/price types (vietu veidi) per trip group. Defines bookable service types
(base price, hotel supplement, extra place, excursion, etc.) and their prices.
One row per option per grupa; piet_saite.vietas_veids references a vietu_veidi row.

Relationships:
  gid  -> grupa.id   (trip group this place type belongs to)

Referenced by:
  piet_saite.vietas_veids -> vietu_veidi.id
  viesnicas_veidi.vietu_veidi_id, vietu_veidi_child_id -> vietu_veidi.id (hotel room type links to base/supplement price)

--------------------------------------------------------------------------------
Fields (from m_vietu_veidi.php, i_pieteikums_calculate, m_pieteikums, m_grupa, m_ligumi)
--------------------------------------------------------------------------------
  id           PK.
  gid          FK -> grupa.id. Trip group.
  tips         Type code. Meaning (from code comments and usage):
               C    = ceļojuma cena (base trip price). max_vecums NULL = adult, not NULL = child.
               CH1  = child base variant. Used with C for base price lines.
               X    = cits (other); e.g. “nav” (no hotel) when nosaukums like '%nav%'; kajīšu cena when cenaEUR>0.
               P    = papildvieta (extra place).
               VV   = hotel supplement (viesnīcas piemaksa); V1 = piemaksa par vienvietīgu numuru (single-room supplement).
               EX   = ekskursija (excursion).
               ED   = ēdināšana (eating/meal).
               Z1   = pēdējās dienas cena (last-day price).
               G    = excluded from participant counts (grupa list; not shown online).
  nosaukums    Display name. Used in contracts (m_ligumi group by), limits warning text.
  cena         Unit price (base currency). Copied to piet_saite in i_pieteikums_calculate.
  cenaLVL      Unit price LVL.
  cenaEUR      Unit price EUR.
  cenaUSD      Unit price USD.
  papildv      Flag: 1 = papildvieta (extra place). Copied to piet_saite; used for bus-seat checks (GetVietasAutobuss).
  persona      Flag: 1 = counts as person. Copied to piet_saite; affects participant counts (tips <> 'G').
  max_vecums   Max age (for age-restricted price, e.g. child). NULL = adult base (PlaceInRoom: tips='C' and max_vecums is null).
  min_vecums   Min age. get_avaialable_online filters by age: isnull(max_vecums,120)>=$age and isnull(min_vecums,0)<=$age.
  no_online    If 1, not shown in online booking (GetAvailable: no_online = 0).
  limits       Max places for this type. When set, GetAiznemtsId/GetAvailable check count from piet_saite; if aiznemts >= limits, option hidden.
  visa_istaba  When true and single traveller (pers_count==1), option hidden unless room type is SINGLE (vtips).

GetId(id): SELECT * FROM vietu_veidi WHERE id=?.
GetAvailable(gid, online_rez_id): SELECT *, isnull(limits,'') as lim WHERE no_online=0 AND gid=?; filters by GetAiznemtsId (limits).
GetAiznemtsId(id, online_rez_id): count of piet_saite rows (deleted=0) with vietas_veids=id, optionally excluding current online_rez.
create(rez, did, vietas_veids): inserts piet_saite for pid/did and vietas_veids, then Calculate(pid).
get_avaialable_online(rez, did, age): full list for reservation/person/age; joins viesnicas_veidi (vietu_veidi_id); filters tips in ('V1','EX','ED','P','Z1','CH1','VV','C') or (tips='X' and cenaEUR>0).
get_avaialable_buy(rez, did, age): after trip start; only EX, ED; excludes already bought (piet_saite for same did, vietas_veids).

Business logic:
- PlaceInRoom: base price = vietu_veidi where gid and tips='C' and max_vecums is null; child base = tips='C' and max_vecums is not null; if no base, tips='X'. Hotel supplement lines (tips VV/V1) soft-deleted then main saite updated; extra row from viesnicas_veidi.vietu_veidi_id.
- m_grupa: participant list excludes piet_saite where vietu_veidi.tips = 'G'.
- m_ligumi: contract lines group by vietu_veidi.nosaukums, kvietas_veids; exclude tips in ('CH1','C','G','P').

Relationship: piet_saite.vietas_veids -> vietu_veidi.id. vietu_veidi.gid = grupa.id.

================================================================================
RELATED TABLE: viesnicas
================================================================================
Hotels (viesnīcas). id, nosaukums, veids (-> viesnicas_veidi?). Used for
assigning hotel room to a piet_saite line.

Relationship: piet_saite.vid -> viesnicas.id.

================================================================================
RELATED TABLE: kajite / kajites_veidi
================================================================================
Cabins (kajītes) and cabin types. piet_saite.kid -> kajite.id;
kajite.veids -> kajites_veidi.id. kvietas_veids in piet_saite = cabin place type.

================================================================================
RELATED TABLE: orderis
================================================================================
Orders/payments. orderis.pid -> pieteikums.id. Sum of orderis.summa used to
check if pieteikums has payments (HasPayment).

================================================================================
RELATED TABLE: marsruts
================================================================================
Route/trip (ceļojums). grupa.mID -> marsruts.id. marsruts.v = trip name (used
in purchase/gift card display).

================================================================================
RELATED TABLE: profili
================================================================================
User profiles (online). online_rez.profile_id -> profili.id. profili linked to
dalibn via pk1, pk2 (personas kods).

================================================================================
TABLE: Bankas  (database: globa, schema dbo)
================================================================================
Banks lookup (banku saraksts). id, code, and display name.

DDL reference: CREATE TABLE [dbo].[Bankas] (SQL Server); PK on id.

Referenced by:
  - Piegadataji.banka -> Bankas.id.

Usage in code:
  - c_davanu_kartes_rekins.php: SELECT nosaukums FROM Bankas WHERE id=? when resolving
    Piegadataji.banka to a bank name.

--------------------------------------------------------------------------------
Fields (from DDL)
--------------------------------------------------------------------------------
id              PK. IDENTITY(1,1).
kods            Bank code (varchar 20).
nosaukums       Bank name (nvarchar 100).

================================================================================
TABLE: Piegadataji  (database: globa, schema dbo)
================================================================================
Suppliers / vendors (piegādātāji) master data for accounting. Used e.g. to match
company registration number (regnr) to official name, address, VAT, and bank details.

DDL reference: CREATE TABLE [dbo].[Piegadataji] (SQL Server); PK on ID; defaults
ir_klients=0, ir_piegadatajs=0, old=0.

Relationships (inferred):
  - banka -> Bankas.id (lookup for bank name in code).

Referenced by usage in code:
  - c_davanu_kartes_rekins.php: SELECT by regnr to compare profili company fields
    with Piegadataji and suggest corrections.

--------------------------------------------------------------------------------
Fields (from DDL)
--------------------------------------------------------------------------------
ID              PK. IDENTITY(1,1).
nosaukums       Name (nvarchar 100).
adrese          Address line 1 (nvarchar 100).
adrese2         Address line 2 (nvarchar 100).
regnr           Registration number (varchar 20); indexed in queries by regnr.
PVN_regnr       VAT registration number (varchar 20).
banka           Bank id (int); join to Bankas for nosaukums.
bankas_konts    Bank account (varchar 50).
piezimes       Notes (ntext).
konts           Account / legacy account field (varchar 50).
veids           Type flag (char 1).
atlaide         Discount (numeric 18,0).
fax             Fax (varchar 20).
ir_klients      Is client (bit), NOT NULL, default 0.
ir_piegadatajs  Is supplier (bit), NOT NULL, default 0.
sd_konts        Ledger-related account codes (varchar 50).
sk_konts        (varchar 50).
gd_konts        (varchar 50).
gk_konts        (varchar 50).
old             Legacy/filter flag for accounting (bit), NOT NULL, default 0;
                extended property: grāmatvedībai filtram.
telefons        Phone (nvarchar 20).
epasts          Email (nvarchar 100).

================================================================================
TABLE: epasts  (database: globa, schema dbo)
================================================================================
Outgoing email queue/log table. Application code inserts rows for later sending
by mailer process/service; status and timestamps are updated after attempts.

DDL reference: CREATE TABLE [dbo].[epasts] (SQL Server); PK on id.

--------------------------------------------------------------------------------
Fields (from DDL)
--------------------------------------------------------------------------------
id              PK. IDENTITY(1,1).
to              Recipient email address (nvarchar 255).
subject         Message subject (nvarchar 255).
text            Message body/content (nvarchar max).
date            Created/queued timestamp (datetime).
send_status     Send result/status code (int).
send_time       Actual send-attempt timestamp (datetime).
from_proc       Source process/job/module name (nvarchar 63).
encoded         Encoding flag (bit).

================================================================================
SUMMARY: pieteikums flow
================================================================================
Online: online_rez (1) -> pieteikums (N per participant/trip) -> piet_saite (N per
service/room/cabin). Each pieteikums has one did (dalibn), one gid (grupa).
Payments: orderis.pid -> pieteikums.id. Prices and totals are recalculated by
pieteikums_calculate_jauns and PHP helpers (i_pieteikums_calculate.php).

================================================================================
ACCOUNTING DATABASES (separate server)
================================================================================
Accounting data lives on another SQL Server instance (not the main application DB).
Each fiscal/accounting year is stored in its own database named sXXXX, where XXXX
is the four-digit year (e.g. s2026, s2025). Cross-year reference data shared by all
years is in a database named kopiga.

--------------------------------------------------------------------------------
Connection from PHP (Db in m_init_utf.php)
--------------------------------------------------------------------------------
Accounting databases are opened through the same Db class as the main site DB.
The class is defined in online2/m_init_utf.php (included as m_init_utf.php from
the application include path).

  - Main site: Db::__construct() connects to SQL Server instance SER-DB3\mssql2008,
    database globa, and stores the handle in $this->conn (used by Db::Query and
    related helpers).

  - Accounting: Db::connectAccounting($dbname) connects to a different instance,
    SER-1\SQL14. The connectionInfo uses "Database" => $dbname (the caller passes
    the year database name such as s2026 or the shared name kopiga), SQL auth
    Uid "www_globa", PWD, TrustServerCertificate, and "CharacterSet" => "UTF-8"
    (sqlsrv: UTF-8 parameters and nvarchar text), then assigns sqlsrv_connect(...)
    to $this->conn.

After connectAccounting() runs on a given Db object, that object's $this->conn
refers to the accounting server — not globa. To use main globa and accounting in
the same HTTP request without losing either connection, the intended pattern is:
create two instances of Db. One instance keeps the constructor-opened globa link;
call connectAccounting($dbname) only on the other instance so each object holds
its own sqlsrv handle in $this->conn. In PHP this is valid: each new Db() has
separate instance properties, so two connections can coexist.

Model functions that need both databases should follow that pattern (two Db
objects) rather than reusing one Db and switching connectAccounting() on it.

Models (e.g. online2/m_rekini.php) should require m_init_utf.php (with the same
path_to_files pattern as other online2 models), instantiate Db from that file, and
call connectAccounting($dbname) on a dedicated Db instance when accessing Rekini /
Rekini_tr. No extra wrapper around Db is required beyond normal require_once and
new Db().

Example year database below: s2026 (same table shapes in other sXXXX databases).

================================================================================
TABLE: Rekini  (database: sXXXX, schema dbo)
================================================================================
Invoice / rēķins header. One row per issued invoice in that accounting year.

DDL reference: CREATE TABLE [dbo].[Rekini] (SQL Server); defaults on apmaksats=0,
changed=1, transp_rek=0.

Relationships (inferred from names and typical usage):
  - klients, maksatajs     -> likely FK to client/payer entities in kopiga or
                             local lookup tables (not verified here).
  - pid                    -> pieteikums.id on the main application database (globa).
                             Cross-server logical reference (accounting sXXXX vs globa);
                             DB FK across instances is typically not used.

Gift card online invoice (c_davanu_kartes_rekins_generet.php, m_rekini.php):
  Before INSERT: if Rekini.pid = pieteikums.id already exists in sYYYY, skip insert
  and return message "Rekins jau izveidots". Otherwise always INSERT (no update).
  Year DB sYYYY from payment date. num from
  GetNextInvoiceNum(year, '/ON'); numPostFix '/ON'. klients and maksatajs set to
  Piegadataji.ID (globa); klients_nos / maksatajs_nos from company name. Amount
  from pieteikums.dk_summa. Payment date: user enters dd.mm.yyyy; Db::sql_date()
  converts to yyyy-mm-dd for datums_apm, datums_izr, datums_grm. Rekini header
  INSERT cannot use OUTPUT (triggers on Rekini); new id taken as SELECT MAX(id)
  FROM Rekini immediately after insert. Unicode text: Db::nvarcharParam() in
  m_init_utf.php binds UTF-8 strings as NVARCHAR (same effect as N'...' literals).
  klients_nos: mb_substr 100 then nvarcharParam. apraksts: mb_substr 200 (UTF-8),
  nvarcharParam (no _win). Rekini.pid set to pieteikums.id (same as Rekini_tr.globa_pid).

--------------------------------------------------------------------------------
Fields
--------------------------------------------------------------------------------
id              PK. IDENTITY(1,1).
pid             Link to globa pieteikums.id (application booking / gift-card row).
num             Invoice number (sequence within year/noliktava rules).
noliktava       Single-char warehouse / stock location flag.
klients         Client ID (debtor / invoice recipient).
klients_nos     Client name snapshot (nvarchar 100).
maksatajs       Payer ID (may differ from klients).
maksatajs_nos   Payer name snapshot.
datums_apm      Payment-related date (apmaksas konteksts).
dienas_apm      Term in days (apmaksas dienas).
datums_izr      Issue date (izrakstīšanas datums).
datums_grm      Ledger / booking date (grāmatvedības datums).
valuta          Currency code (3 chars).
kurss           Exchange rate to base currency.
summa           Amount (base currency), decimal(18,2).
summa_val       Amount in invoice currency.
pvn             VAT amount (base).
pvn_val         VAT amount in invoice currency.
summa_pvn       Total including VAT (base).
summa_pvn_val   Total including VAT in invoice currency.
document        Link to document record (local id).
apmaksats       Paid flag; default 0.
changed         Modified flag; default 1; NOT NULL.
numPostFix      Invoice type / number suffix (e.g. /ON for gift card online).
gdocument       Global / grouped document id (if used).
transp_rek      Transport-invoice flag; default 0.
piezimes        Notes (up to 1000 chars).
pvn_pants       VAT breakdown / classification text (pants = PVN kategorijas).

================================================================================
TABLE: Rekini_tr  (database: sXXXX, schema dbo)
================================================================================
Invoice lines / rēķina rindas. Child rows for one Rekini invoice.

DDL reference: CREATE TABLE [dbo].[Rekini_tr]; default pvn_likme_proc = 0.

Relationships:
  rekins          -> Rekini.id (invoice header for this line).

Gift card online line: resurss like YY.D.2 (YY = last two digits of payment year);
debets 2.3.4.X, kredits 5.2.2.4; apraksts Dāvanu karte ON-LINE (amount int);
globa_pid = pieteikums.id.

--------------------------------------------------------------------------------
Fields
--------------------------------------------------------------------------------
id              PK. IDENTITY(1,1).
num             Line number / ordering.
rekins          FK -> Rekini.id (invoice header).
resurss         Resource code or id (varchar 50).
debets          Debit account (ledger code, varchar 50).
kredits         Credit account (ledger code, varchar 50).
apraksts        Line description (nvarchar 200).
cena_val        Unit price in invoice currency.
cena            Unit price (base).
cena_bez_pvn    Unit price excluding VAT.
skaits          Quantity (numeric integer).
summa           Line total (base currency).
summa_val       Line total in invoice currency.
pvn_koef        VAT coefficient / multiplier (float).
pvn             VAT amount (base).
pvn_val         VAT amount in invoice currency.
summa_pvn       Line total including VAT (base).
summa_pvn_val   Line total including VAT in invoice currency.
atlaide         Discount per unit or line discount input.
summa_atl       Discount amount (after calculation).
globa_pid       Optional link to Globa application data (e.g. pieteikums id).
globa_oid       Optional link to Globa order / payment id.
pvn_likme_proc  VAT rate in percent; default 0; decimal(10,2).

================================================================================
SUMMARY: accounting vs application
================================================================================
Application booking data (pieteikums, orderis, …) lives on the main site database.
Posted invoices and ledger lines for accounting are in per-year databases sXXXX on
the accounting server; shared masters use kopiga. Rekini.pid points to
pieteikums.id (globa) at header level; Rekini_tr.globa_pid / globa_oid are
additional line-level bridges to Globa (verify in code before relying on semantics).
*/
