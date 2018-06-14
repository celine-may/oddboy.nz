<section class="view" data-view="home">
  <header class="header">
    <button class="scroll-cta do-slide-up do-scroll-down" data-view="projects">
      <span class="scroll-circle">
        <span class="scroll-bg"></span>
      </span>
      <svg class="shape-scroll-cta">
        <use xlink:href="#shape-scroll-cta"></use>
      </svg>
    </button>
  </header>

  <section class="section projects-container bg-color secondary">
    <?php include('layouts/grid.php'); ?>
    <div class="title-wrapper">
      <h2 class="title">Oddboy<br/>projects<span class="text-color accent">.</span></h2>
      <div class="title-icons">
        <svg class="shape shape-gamepad">
          <use xlink:href="#shape-gamepad"></use>
        </svg>
        <svg class="shape shape-vr-gear">
          <use xlink:href="#shape-vr-gear"></use>
        </svg>
        <svg class="shape shape-atom">
          <use xlink:href="#shape-atom"></use>
        </svg>
      </div>
    </div>

    <div class="projects-wrapper">
      <a href="#" target="_blank" class="project do-show-project-details" data-project="jrump">
        <div class="project-overlay"></div>
        <div class="project-content">
          <h2 class="title project-title do-anim-y">Jrump<span class="text-color accent">.</span></h2>
          <p class="lead project-lead do-anim-show-y">Game Design + Development</p>
        </div>
        <svg class="project-arrow shape-arrow do-anim-show-y">
          <use xlink:href="#shape-arrow"></use> <!-- TODO: use new arrow -->
        </svg>
      </a>
    </div>

    <div class="title-wrapper">
      <h2 class="title">Projects<br/>for clients<span class="text-color accent">.</span></h2>
      <div class="title-icons">
        <svg class="shape shape-gamepad">
          <use xlink:href="#shape-gamepad"></use>
        </svg>
        <svg class="shape shape-vr-gear">
          <use xlink:href="#shape-vr-gear"></use>
        </svg>
        <svg class="shape shape-atom">
          <use xlink:href="#shape-atom"></use>
        </svg>
      </div>
    </div>
  </section>
</section>
