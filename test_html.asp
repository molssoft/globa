

  
  <!DOCTYPE html>
<html>
<head>
<meta charset=utf-8 />
<title>JS Bin</title>
<style>
 <style>
     .rotated-text {
    display: inline-block;
    overflow: hidden;
    width: 1.5em;
}
.rotated-text__inner {
    display: inline-block;
    white-space: nowrap;
    /* this is for shity "non IE" browsers
       that doesn't support writing-mode */
    -webkit-transform: translate(1.1em,0) rotate(90deg);
       -moz-transform: translate(1.1em,0) rotate(90deg);
         -o-transform: translate(1.1em,0) rotate(90deg);
            transform: translate(1.1em,0) rotate(90deg);
    -webkit-transform-origin: 0 0;
       -moz-transform-origin: 0 0;
         -o-transform-origin: 0 0;
            transform-origin: 0 0;
   /* IE9+ */
   -ms-transform: none;
   -ms-transform-origin: none;
   /* IE8+ */
   -ms-writing-mode: tb-rl;
   /* IE7 and below */
   *writing-mode: tb-rl;
}
.rotated-text__inner:before {
    content: "";
    float: left;
    margin-top: 100%;
}

/* mininless css that used just for this demo */
.container {
  float: left;
}
</style>
</head>
<body>
  <div class="container">
    <div class="rotated-text"><span class="rotated-text__inner">Easy</span></div>
  </div>
   <div class="container">
    <div class="rotated-text"><span class="rotated-text__inner">Normal</span></div>
     </div>
   <div class="container">
    <div class="rotated-text"><span class="rotated-text__inner">Hard</span></div>
</div>
</body>
</html>