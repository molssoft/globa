<center>
<h3>Autobusa bildes</h3>
<a href="?f=upload_images&id=<?=$data['autobuss']['id'];?>">Pievienot bildes</a>
<br>
<br>
<? if (!empty($data['bildes'])){
	?>
	<table>
	<tr>
		
	<?
	$i=0;
	foreach ($data['bildes'] as $row){
		$imagename = $row['bilde'];
		$folder = "https://www.impro.lv/autobusu_bildes/";

		
		?>
		<td style="height:160px;margin-bottom:10px">
				<?	if ($row['galvena'])
					{
						?>
						Galvenâ bilde
						<?php
					}
					else{
						echo '<a style="font-size:90%;" href="?f=set_image_main&id='.$data['autobuss']['id'].'&image_id='.$row['id'].'">Uzstâdît&nbsp;kâ&nbsp;galveno</a>';
					}
					
					
					echo '	<div style="max-height:120px;max-width:60px;border:1px solid #e6e6e6; border-radius: 5px;margin-bottom:5px">
						<a target="_blank" href="'.$folder.$imagename.'">
							<img src="'.$folder.$imagename.'" class="" style="max-width:100%;max-height:120px;margin:auto;display:block"/>
						</a>
						</div>';
						
				
					echo '<a href="?f=delete_bilde&id='.$data['autobuss']['id'].'&image_id='.$row['id'].'" onclick="return confirm(\'Vai tieðâm dzçst ðo bildi?\');">
							<img title="Dzçst bildi" src="impro/bildes/dzest.jpg" alt="" ></a>';
					//	class="btn btn-primary" style="display:block;margin:auto;background:#F48E8E;border:1px solid #E38282;">Dzçst</a>
					
					?>
					</div>
					</td>
					<?
					$i++;
					if ($i>=8){
					$i=0;
					?>
					</tr><tr>
					<?
						}
		
		
	}
	?>
	</tr>
	</table>
	<?
}					