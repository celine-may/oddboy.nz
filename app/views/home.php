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

  <section class="section projects-wrapper bg-color secondary">
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

    <a href="http://celine.kiwi" target="_blank">
      <article class="project do-show-project-details">
        <div class="project-bg" data-project="celine"></div>
        <div class="project-content">
          <h2 class="title project-title">Celine Portfolio<span class="text-color accent">.</span></h2>
          <p class="lead project-lead project-anim">Web design</p>
        </div>
        <svg class="project-arrow project-anim shape-arrow">
          <use xlink:href="#shape-arrow"></use> <!-- TODO: use new arrow -->
        </svg>
      </article>
    </a>

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
