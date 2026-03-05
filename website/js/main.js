/**
 * Home Kitchen Website - Main JavaScript
 * Bilingual (AR/EN), smooth scroll, animations, responsive nav
 */

(function () {
  'use strict';

  // ===== State =====
  let currentLang = 'ar';

  // ===== DOM Elements =====
  const htmlRoot = document.getElementById('html-root');
  const langToggle = document.getElementById('lang-toggle');
  const nav = document.getElementById('nav');
  const navToggle = document.getElementById('nav-toggle');
  const navMenu = document.getElementById('nav-menu');

  // ===== Language Toggle =====
  function setLanguage(lang) {
    currentLang = lang;
    htmlRoot.lang = lang === 'ar' ? 'ar' : 'en';
    htmlRoot.dir = lang === 'ar' ? 'rtl' : 'ltr';
    document.body.setAttribute('lang', lang);

    // Update all [data-ar] and [data-en] elements
    document.querySelectorAll('[data-ar][data-en]').forEach((el) => {
      const text = lang === 'ar' ? el.getAttribute('data-ar') : el.getAttribute('data-en');
      if (text) el.textContent = text;
    });

    // Update lang toggle button text (shows the language you'll switch TO)
    const toggleText = document.getElementById('lang-toggle-text');
    if (toggleText) toggleText.textContent = lang === 'ar' ? 'EN' : 'عربي';
  }

  if (langToggle) langToggle.addEventListener('click', () => {
    currentLang = currentLang === 'ar' ? 'en' : 'ar';
    setLanguage(currentLang);
  });

  // ===== Nav Scroll =====
  if (nav) {
    function onScroll() {
      if (window.scrollY > 50) nav.classList.add('scrolled');
      else nav.classList.remove('scrolled');
    }
    window.addEventListener('scroll', onScroll, { passive: true });
  }

  // ===== Mobile Nav Toggle =====
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

  // ===== Intersection Observer for Animations =====
  const observerOptions = {
    root: null,
    rootMargin: '0px 0px -80px 0px',
    threshold: 0.1,
  };

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible');
      }
    });
  }, observerOptions);

  document.querySelectorAll('.service-card, .about-card, .step-card, .audience-card').forEach((el) => {
    observer.observe(el);
  });

  // ===== Smooth Scroll for anchor links =====
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

  // ===== Initialize =====
  setLanguage('ar');
})();
