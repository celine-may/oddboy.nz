<?php

include('config.php');

?><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">

  <!-- TODO: Meta tags -->
  <title>Oddboy</title>
  <meta name="description" content="">

  <meta property="og:site_name" content="Oddboy.nz">
  <meta property="og:type" content="Website">
  <meta property="og:url" content="http://oddboy.nz">
  <meta property="og:title" content="Oddboy">
  <meta property="og:description" content="">
  <meta property="og:image" content="http://www.oddboy.nz/assets/images/oddboy-fb.png">
  <meta property="fb:app_id" content="">

  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">

  <!-- TODO: Favicon & icon images
  <link rel="icon" href="<?php echo IMAGES_PATH; ?>favicon.png" type="image/x-icon"/>

  <link rel="apple-touch-icon" sizes="76x76" href="<?php echo IMAGES_PATH; ?>icons/touch-icon-ipad.png">
  <link rel="apple-touch-icon" sizes="120x120" href="<?php echo IMAGES_PATH; ?>icons/touch-icon-iphone@2x.png">
  <link rel="apple-touch-icon" sizes="152x152" href="<?php echo IMAGES_PATH; ?>icons/touch-icon-ipad@2x.png">
  <link rel="apple-touch-icon" sizes="167x167" href="<?php echo IMAGES_PATH; ?>icons/touch-icon-ipad-pro@2x.png">
  <link rel="apple-touch-icon" sizes="180x180" href="<?php echo IMAGES_PATH; ?>icons/touch-icon-iphone@3x.png">
  -->

  <?php foreach ($assets['stylesheets'] as $file_path) : ?>
    <link rel="stylesheet" href="<?php echo $file_path ?>">
  <?php endforeach ?>

  <script>
    window.App = {};
    App.path = "<?php echo PATH; ?>";
    App.FXs = [];
  </script>
</head>

<body>
  <?php include_once('assets/svgs/svg-defs.svg'); ?>

  <?php include('layouts/ui.php'); ?>
  <?php include('layouts/loader.php'); ?>

  <?php foreach ($assets['javascripts'] as $file_path) : ?>
    <script src="<?php echo $file_path; ?>"></script>
  <?php endforeach; ?>
</body>
</html>
