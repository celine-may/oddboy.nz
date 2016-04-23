<?php

include('config.php');

/* Request */
$q = isset($_GET['q']) ? explode('/', $_GET['q']) : array();
$controller = isset($q[0]) ? $q[0] : 'home';

include("controllers/$controller.php");

?><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">

  <!-- TODO: Meta tags -->
  <title><?php echo $pageTitle; ?></title>
  <meta name="description" content="<?php echo $pageDescription; ?>">

  <meta property="og:site_name" content="Oddboy.nz">
  <meta property="og:type" content="Website">
  <meta property="og:url" content="http://oddboy.nz">
  <meta property="og:title" content="<?php echo $pageTitle; ?>">
  <meta property="og:description" content="<?php echo $pageDescription; ?>">
  <meta property="og:image" content="http://www.oddboy.nz/assets/images/oddboy-fb.jpg">
  <meta property="fb:app_id" content="">

  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="X-UA-Compatible" content="IE=Edge">

  <link rel="icon" href="<?php echo IMAGES_PATH; ?>layout/favicon-16x16.png" sizes="16x16">
  <link rel="icon" href="<?php echo IMAGES_PATH; ?>layout/favicon-32x32.png" sizes="32x32">
  <link rel="icon" href="<?php echo IMAGES_PATH; ?>layout/favicon-48x48.png" sizes="48x48">

  <link rel="apple-touch-icon" sizes="76x76" href="<?php echo IMAGES_PATH; ?>layout/touch-icon-ipad.png">
  <link rel="apple-touch-icon" sizes="120x120" href="<?php echo IMAGES_PATH; ?>layout/touch-icon-iphone@2x.png">
  <link rel="apple-touch-icon" sizes="152x152" href="<?php echo IMAGES_PATH; ?>layout/touch-icon-ipad@2x.png">
  <link rel="apple-touch-icon" sizes="167x167" href="<?php echo IMAGES_PATH; ?>layout/touch-icon-ipad-pro@2x.png">
  <link rel="apple-touch-icon" sizes="180x180" href="<?php echo IMAGES_PATH; ?>layout/touch-icon-iphone@3x.png">

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

  <main id="main" class="main" data-view="<?php echo $controller; ?>">
    <?php include('layouts/ui.php'); ?>
    <div class="panel lhs"></div>
    <div class="panel rhs"></div>
    <?php if (is_file("views/$controller.php")) include("views/$controller.php"); ?>
  </main>

  <?php include('layouts/loader.php'); ?>

  <?php foreach ($assets['javascripts'] as $file_path) : ?>
    <script src="<?php echo $file_path; ?>"></script>
  <?php endforeach; ?>
</body>
</html>
