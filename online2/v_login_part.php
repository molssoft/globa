<form class="form-signin " method="post" accept-charset="utf-8" action="c_login.php?f=login">
				
				<input name=post value=1 hidden>
				<input name="gift_card" value="<?=(isset($data['gift_card']) && $data['gift_card'] ?  1 : 0)?>" type="hidden"/>
				<? if (isset($data['message'])) {?><div class="alert alert-danger"><?echo $data['message'];?></div><?}?>
				<? if (isset($data['info']['msg'])){?><div class="alert alert-success"><? echo $data['info']['msg'];?></div><?}?>
				<input name="eadr" class="form-control" id="eadr" placeholder="E-pasts" value="<? if (isset($data['info']['email'])) echo $data['info']['email'];?>"
					required autofocus autocomplete="off" >
				<input type="password" name="pass" class="form-control"
					placeholder="Parole" required> 
					
					
				
				<label class="forget-pass"> <a id="forgot" href="c_login.php?f=forgot" onclick="forgot();">Atgâdinât paroli</a>
				</label>
				<div class="col-12 text-left">
				<input type="checkbox" name="remember_me" value=""> Atcerçties mani no ðîs ierîces<br></div>
				<button class="btn btn-lg btn-primary btn-block" type="submit">Ieiet</button>

			</form>
			
			<form class="form-signin " method="post" accept-charset="utf-8" action="c_register.php?f=name">
				<h4  <? if (!isset($data['gift_card']) || !$data['gift_card']) {?>style="margin-top:50px"<?}?>>Ja neesi reìistrçjies, tad</h4>
				<button class="btn btn-lg btn-primary btn-block" type="submit">Reìistrçjies ðeit</button>
				
			</form>