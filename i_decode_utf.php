<?
// Custom Windows-1257 (Baltic) -> UTF-8 decoder without using PHP's iconv/mb_*.
// Decodes by iterating bytes and replacing Latvian special characters via a lookup.

// Encodes a Unicode code point (integer) to a UTF-8 byte string
function _cp_to_utf8($cp){
	if ($cp <= 0x7F) {
		return chr($cp);
	} elseif ($cp <= 0x7FF) {
		return chr(0xC0 | (($cp >> 6) & 0x1F))
		     . chr(0x80 | ($cp & 0x3F));
	} elseif ($cp <= 0xFFFF) {
		return chr(0xE0 | (($cp >> 12) & 0x0F))
		     . chr(0x80 | (($cp >> 6) & 0x3F))
		     . chr(0x80 | ($cp & 0x3F));
	} else {
		return chr(0xF0 | (($cp >> 18) & 0x07))
		     . chr(0x80 | (($cp >> 12) & 0x3F))
		     . chr(0x80 | (($cp >> 6) & 0x3F))
		     . chr(0x80 | ($cp & 0x3F));
	}
}

// Windows-1257 byte (0x00-0xFF) -> Unicode codepoint map (only special LV letters and a few punctuation)
// Note: ASCII 0x00..0x7F maps 1:1 and is handled directly
$__WIN1257_SPECIALS = array(
	// punctuation frequently seen in pages
	0x80 => 0x20AC, // €
	0x82 => 0x201A, // ‚
	0x84 => 0x201E, // „
	0x85 => 0x2026, // …
	0x86 => 0x2020, // †
	0x87 => 0x2021, // ‡
	0x89 => 0x2030, // ‰
	0x8B => 0x2039, // ‹
	0x8D => 0x00A8, // ¨ (diaeresis)
	0x8E => 0x02C7, // ˇ (caron)
	0x8F => 0x00B8, // ¸ (cedilla)
	0x91 => 0x2018, // ‘
	0x92 => 0x2019, // ’
	0x93 => 0x201C, // “
	0x94 => 0x201D, // ”
	0x95 => 0x2022, // •
	0x96 => 0x2013, // –
	0x97 => 0x2014, // —
	0x99 => 0x2122, // ™
	0x9B => 0x203A, // ›

	// Latvian letters (uppercase)
	0xC0 => 0x0100, // Ā
	0xC3 => 0x0106, // Ć (used in some data)
	0xC8 => 0x010C, // Č
	0xCA => 0x0112, // Ē
	0xCC => 0x0116, // Ė (fallback)
	0xCE => 0x012A, // Ī
	0xD2 => 0x0136, // Ķ
	0xD3 => 0x013B, // Ļ
	0xD5 => 0x0145, // Ņ
	0xD8 => 0x0160, // Š
	0xDA => 0x016A, // Ū
	0xDE => 0x017D, // Ž
	0xAA => 0x0122, // Ģ (position varies; include here for robustness)
	0xDB => 0x0156, // Ŗ
	0xA8 => 0x0118, // Ę (fallback)

	// Latvian letters (lowercase)
	0xE0 => 0x0101, // ā
	0xE3 => 0x0107, // ć (used in some data)
	0xE8 => 0x010D, // č
	0xEA => 0x0113, // ē
	0xEC => 0x0117, // ė (fallback)
	0xEE => 0x012B, // ī
	0xF2 => 0x0137, // ķ
	0xF3 => 0x013C, // ļ
	0xF5 => 0x0146, // ņ
	0xF8 => 0x0161, // š
	0xFA => 0x016B, // ū
	0xFE => 0x017E, // ž
	0xBA => 0x0123, // ģ (position varies; include here for robustness)
	0xFB => 0x0157, // ŗ
);

function WinToUtf($s){
	global $__WIN1257_SPECIALS;
	$out = '';
	$len = strlen($s);
	for ($i=0; $i<$len; $i++){
		$byte = ord($s[$i]);
		if ($byte < 0x80){
			$out .= $s[$i];
			continue;
		}
		if (isset($__WIN1257_SPECIALS[$byte])){
			$out .= _cp_to_utf8($__WIN1257_SPECIALS[$byte]);
		} else {
			// For bytes not in the explicit map, approximate by treating as Latin-1 codepoint
			$out .= _cp_to_utf8($byte);
		}
	}
	return $out;
}

// ---- Reverse: UTF-8 -> Windows-1257 ----

// Decode UTF-8 into an array of Unicode code points
function _utf8_to_codepoints($s){
    $codepoints = array();
    $len = strlen($s);
    for ($i=0; $i<$len; ){
        $b1 = ord($s[$i]);
        if ($b1 < 0x80){
            $codepoints[] = $b1; $i++; continue;
        }
        // 2-byte
        if (($b1 & 0xE0) == 0xC0 && $i+1 < $len){
            $b2 = ord($s[$i+1]);
            $cp = (($b1 & 0x1F) << 6) | ($b2 & 0x3F);
            $codepoints[] = $cp; $i += 2; continue;
        }
        // 3-byte
        if (($b1 & 0xF0) == 0xE0 && $i+2 < $len){
            $b2 = ord($s[$i+1]); $b3 = ord($s[$i+2]);
            $cp = (($b1 & 0x0F) << 12) | (($b2 & 0x3F) << 6) | ($b3 & 0x3F);
            $codepoints[] = $cp; $i += 3; continue;
        }
        // 4-byte
        if (($b1 & 0xF8) == 0xF0 && $i+3 < $len){
            $b2 = ord($s[$i+1]); $b3 = ord($s[$i+2]); $b4 = ord($s[$i+3]);
            $cp = (($b1 & 0x07) << 18) | (($b2 & 0x3F) << 12) | (($b3 & 0x3F) << 6) | ($b4 & 0x3F);
            $codepoints[] = $cp; $i += 4; continue;
        }
        // Fallback for invalid sequences: pass byte through
        $codepoints[] = $b1; $i++;
    }
    return $codepoints;
}

// Convert UTF-8 string to Windows-1257 bytes using explicit reverse mapping
function UtfToWin($s){
    global $__WIN1257_SPECIALS;
    // Build reverse map (codepoint => byte)
    static $rev = null;
    if ($rev === null){
        $rev = array();
        foreach ($__WIN1257_SPECIALS as $byte=>$cp){
            $rev[$cp] = $byte;
        }
    }
    $out = '';
    $cps = _utf8_to_codepoints($s);
    foreach ($cps as $cp){
        if ($cp <= 0x7F){
            $out .= chr($cp);
            continue;
        }
        if (isset($rev[$cp])){
            $out .= chr($rev[$cp]);
            continue;
        }
        // Fallback: if within 0x80..0xFF, approximate to same byte value
        if ($cp >= 0x80 && $cp <= 0xFF){
            $out .= chr($cp);
        } else {
            // Unmappable -> replace with '?'
            $out .= '?';
        }
    }
    return $out;
}

?>


