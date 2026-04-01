<br>
<br>
<a  href="c_reservation.php?f=CancelReservation" 
 class="btn btn-block btn-default"
 style="background-position:0 0"
	onclick="return confirm('Vai tieðâm vçlaties dzçst uzsâkto rezervâciju un atgriezties uz sâkumu?');">
	Atcelt</a>
<!-- TAimeris, kas saglabâ lietotâja aktivitâti, lai varçtu kosntatçt, kad lietotâjs atslçdzies no sistçmas un izsûtît atgâdinâjumu par nepabeigtu rezervâciju -->	
<script>
$(function() {
	update_user_sess();
	setInterval(function(){update_user_sess();}, 10000);
});
function update_user_sess(){
 $.ajax({
    url : 'm_user_session.php?method=save&param=<?=$_SESSION['profili_id'];?>', //
   })
}
</script>
					