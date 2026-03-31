/**
 * Home Kitchen Website — لغة، تمرير، تفاعل، شريط تقدم، أكورديون خدمات
 */

(function () {
  'use strict';

  let currentLang = 'ar';

  const htmlRoot = document.getElementById('html-root');
  const langToggle = document.getElementById('lang-toggle');
  const nav = document.getElementById('nav');
  const navToggle = document.getElementById('nav-toggle');
  const navMenu = document.getElementById('nav-menu');
  const scrollProgress = document.getElementById('scroll-progress');
  const heroBg = document.getElementById('hero-bg');
  const heroScroll = document.getElementById('hero-scroll');
  const backToTop = document.getElementById('back-to-top');

  function setLanguage(lang) {
    currentLang = lang;
    htmlRoot.lang = lang === 'ar' ? 'ar' : 'en';
    htmlRoot.dir = lang === 'ar' ? 'rtl' : 'ltr';
    document.body.setAttribute('lang', lang);

    document.querySelectorAll('[data-ar][data-en]').forEach((el) => {
      if (el.classList.contains('service-toggle')) return;
      const text = lang === 'ar' ? el.getAttribute('data-ar') : el.getAttribute('data-en');
      if (text) el.textContent = text;
    });

    const toggleText = document.getElementById('lang-toggle-text');
    if (toggleText) toggleText.textContent = lang === 'ar' ? 'EN' : 'عربي';

    document.querySelectorAll('.service-toggle').forEach((btn) => {
      const expanded = btn.getAttribute('aria-expanded') === 'true';
      updateServiceToggleLabel(btn, expanded);
    });
  }

  function updateServiceToggleLabel(btn, expanded) {
    const arExpand = btn.getAttribute('data-ar-expand') || 'عرض التفاصيل ▼';
    const enExpand = btn.getAttribute('data-en-expand') || 'Show details ▼';
    const arCollapse = btn.getAttribute('data-ar-collapse') || 'إخفاء التفاصيل ▲';
    const enCollapse = btn.getAttribute('data-en-collapse') || 'Hide details ▲';
    if (expanded) {
      btn.textContent = currentLang === 'ar' ? arCollapse : enCollapse;
    } else {
      btn.textContent = currentLang === 'ar' ? arExpand : enExpand;
    }
  }

  if (langToggle) {
    langToggle.addEventListener('click', () => {
      currentLang = currentLang === 'ar' ? 'en' : 'ar';
      setLanguage(currentLang);
    });
  }

  if (nav) {
    function onScrollNav() {
      if (window.scrollY > 50) nav.classList.add('scrolled');
      else nav.classList.remove('scrolled');
    }
    window.addEventListener('scroll', onScrollNav, { passive: true });
  }

  if (scrollProgress) {
    window.addEventListener(
      'scroll',
      () => {
        const h = document.documentElement;
        const scrolled = (h.scrollTop / (h.scrollHeight - h.clientHeight)) * 100;
        scrollProgress.style.width = `${Math.min(100, Math.max(0, scrolled))}%`;
      },
      { passive: true },
    );
  }

  if (heroBg && !window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    window.addEventListener(
      'scroll',
      () => {
        const y = window.scrollY;
        const max = 400;
        const p = Math.min(y / max, 1);
        heroBg.style.transform = `translateY(${p * 24}px)`;
      },
      { passive: true },
    );
  }

  if (heroScroll) {
    heroScroll.addEventListener('click', () => {
      const services = document.getElementById('services');
      if (services) services.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
  }

  if (backToTop) {
    window.addEventListener(
      'scroll',
      () => {
        if (window.scrollY > 500) backToTop.classList.add('visible');
        else backToTop.classList.remove('visible');
      },
      { passive: true },
    );
    backToTop.addEventListener('click', () => {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  }

  if (navToggle && navMenu) {
    navToggle.addEventListener('click', () => {
      navMenu.classList.toggle('active');
      navToggle.classList.toggle('active');
    });
    navMenu.querySelectorAll('a').forEach((link) => {
      link.addEventListener('click', () => {
        navMenu.classList.remove('active');
        navToggle.classList.remove('active');
      });
    });
  }

  const observerOptions = {
    root: null,
    rootMargin: '0px 0px -60px 0px',
    threshold: 0.08,
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) entry.target.classList.add('visible');
    });
  }, observerOptions);

  document.querySelectorAll('.service-card, .about-card, .step-card, .audience-card').forEach((el) => {
    observer.observe(el);
  });

  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener('click', function (e) {
      const href = this.getAttribute('href');
      if (href === '#') return;
      const target = document.querySelector(href);
      if (target) {
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      }
    });
  });

  document.querySelectorAll('.service-card').forEach((card) => {
    const body = card.querySelector('.service-body');
    const btn = card.querySelector('.service-toggle');
    if (!body || !btn) return;

    btn.setAttribute('data-ar-expand', 'عرض التفاصيل ▼');
    btn.setAttribute('data-en-expand', 'Show details ▼');
    btn.setAttribute('data-ar-collapse', 'إخفاء التفاصيل ▲');
    btn.setAttribute('data-en-collapse', 'Hide details ▲');

    btn.addEventListener('click', () => {
      const mq = window.matchMedia('(max-width: 768px)');
      if (!mq.matches) return;
      const expanded = btn.getAttribute('aria-expanded') === 'true';
      const next = !expanded;
      btn.setAttribute('aria-expanded', next ? 'true' : 'false');
      body.classList.toggle('collapsed', !next);
      updateServiceToggleLabel(btn, next);
    });
  });

  function initServiceAccordionLayout() {
    const mq = window.matchMedia('(max-width: 768px)');
    function apply() {
      document.querySelectorAll('.service-card').forEach((card) => {
        const body = card.querySelector('.service-body');
        const btn = card.querySelector('.service-toggle');
        if (!body || !btn) return;
        if (mq.matches) {
          body.classList.add('collapsed');
          btn.setAttribute('aria-expanded', 'false');
          updateServiceToggleLabel(btn, false);
        } else {
          body.classList.remove('collapsed');
          btn.setAttribute('aria-expanded', 'true');
          updateServiceToggleLabel(btn, true);
        }
      });
    }
    apply();
    mq.addEventListener('change', apply);
  }

  initServiceAccordionLayout();
  setLanguage('ar');
})();
