<header class="header">
  <?php include('layouts/grid.php'); ?>
  <div class="header-content">
    <article class="character lhs" data-character="ben">
      <div class="character-content">
        <div class="character-sprites">
          <div class="character-rollover sprite"></div>
          <div class="character-blink sprite"></div>
        </div>
        <a href="mailto:ben@oddboy.nz" class="character-email character-anim">ben@oddboy.nz</a>
        <a href="https://www.behance.net/barkle" target="_blank" class="character-link lead text-color accent character-anim">Portfolio</a>
      </div>
    </article>

    <article class="character rhs" data-character="tom">
      <div class="character-content">
        <div class="character-sprites">
          <div class="character-rollover sprite"></div>
          <div class="character-blink sprite"></div>
        </div>
        <a href="mailto:tom@oddboy.nz" class="character-email character-anim">tom@oddboy.nz</a>
        <a href="https://www.behance.net/Iimbo" target="_blank" class="character-link lead text-color primary character-anim">Portfolio</a>
      </div>
    </article>
  </div>

  <button class="scroll-cta anim2 large-only do-scroll-down">
    <span class="scroll-circle">
      <span class="scroll-bg"></span>
    </span>
    <svg class="shape-scroll-cta">
      <use xlink:href="#shape-scroll-cta"></use>
    </svg>
  </button>
</header>

<section class="section contact-wrapper bg-color accent">
  <?php include('layouts/grid.php'); ?>
  <div class="section-content contact">
    <h1 class="title">
      Holla at an <br class="xsmall-hidden"><span class="text-color primary">odd<span class="flipped">b</span>oy</span>. Let's make sweet, sweet ????.
    </h1>
    <span class="title-separator bg-color primary"></span>
    <p class="lead vcard">
      <a href="mailto:holla@oddboy.nz" class="contact-link email">holla@oddboy.nz</a>
      <a href="tel:+64273463287" class="contact-link tel">+64 273463287</a>
    </p>
  </div>
</section>
