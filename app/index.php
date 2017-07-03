<?php

include('config.php');

$pageTitle = 'Oddboy - Interactive Studio, Auckland, NZ. | Games, Virtual + Augmented Reality, Web';
$pageDescription = 'Oddboy is an interactive studio specializing in games, virtual reality (VR), augmented reality (AR) and digital products.';

?><!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">

  <title><?php echo $pageTitle; ?></title>
  <meta name="description" content="<?php echo $pageDescription; ?>">
  <meta name="keywords" content="Virtual reality, digital, Augmented reality, design studio, AR, VR, New Zealand, Auckland, Jrump, gamification, game design, game development, Innovation, Kabashians, Storytelling, Interactive, VR, Applications, VR Training, VR experiential marketing, VR tradeshow exhibit, mobile VR, App development, VR strategy, AR strategy, 360 video, Motion capture, animation, production, VR Development, AR Development, VR Exhibition, AR app"/>

  <meta property="og:site_name" content="Oddboy.nz">
  <meta property="og:type" content="Website">
  <meta property="og:url" content="http://oddboy.nz">
  <meta property="og:title" content="<?php echo $pageTitle; ?>">
  <meta property="og:description" content="<?php echo $pageDescription; ?>">
  <meta property="og:image" content="http://i65.tinypic.com/npf3wl.jpg">
  <meta property="fb:app_id" content=""> <!-- todo: Facebook AppID -->

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
    <link rel="stylesheet" href="<?php echo $file_path . '?v' . time() ?>">
  <?php endforeach ?>

  <script>
    window.App = {};
    App.path = "<?php echo PATH; ?>";
    App.cdnPath = "<?php echo CDN_PATH; ?>";
    App.Controllers = [];
  </script>
</head>

<body>
  <main class="main" data-view="home">
    <?php include('layouts/ui.php'); ?>
    <?php include('views/home.php') ?>
    <?php include('views/talk-to-us.php') ?>
    <?php include('views/what-we-do.php') ?>
  </main>

  <?php include('layouts/loader.php'); ?>

  <?php foreach ($assets['javascripts'] as $file_path) : ?>
    <script src="<?php echo $file_path . '?v' . time()  ?>"></script>
  <?php endforeach; ?>
</body>
</html>
