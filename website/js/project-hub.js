(function () {
  'use strict';

  const htmlRoot = document.getElementById('html-root');
  const langToggle = document.getElementById('lang-toggle');
  let currentLang = 'ar';

  function setLanguage(lang) {
    currentLang = lang;
    htmlRoot.lang = lang === 'ar' ? 'ar' : 'en';
    htmlRoot.dir = lang === 'ar' ? 'rtl' : 'ltr';
    document.body.setAttribute('lang', lang);
    document.querySelectorAll('[data-ar][data-en]').forEach((el) => {
      const text = lang === 'ar' ? el.getAttribute('data-ar') : el.getAttribute('data-en');
      if (text) el.textContent = text;
    });
    const t = document.getElementById('lang-toggle-text');
    if (t) t.textContent = lang === 'ar' ? 'EN' : 'عربي';
  }

  if (langToggle) {
    langToggle.addEventListener('click', () => {
      setLanguage(currentLang === 'ar' ? 'en' : 'ar');
    });
  }

  document.querySelectorAll('.hub-tab').forEach((btn) => {
    btn.addEventListener('click', () => {
      const id = btn.getAttribute('data-panel');
      document.querySelectorAll('.hub-tab').forEach((b) => b.classList.remove('active'));
      document.querySelectorAll('.hub-panel').forEach((p) => p.classList.remove('active'));
      btn.classList.add('active');
      const panel = document.getElementById(id);
      if (panel) panel.classList.add('active');
    });
  });

  document.querySelectorAll('.hub-accordion-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
      const expanded = btn.getAttribute('aria-expanded') === 'true';
      const next = !expanded;
      btn.setAttribute('aria-expanded', next ? 'true' : 'false');
      const panel = btn.nextElementSibling;
      if (panel && panel.classList.contains('hub-accordion-panel')) {
        panel.classList.toggle('open', next);
      }
    });
  });

  document.querySelectorAll('.btn-copy').forEach((btn) => {
    btn.addEventListener('click', () => {
      const text = btn.getAttribute('data-copy');
      if (!text) return;
      navigator.clipboard.writeText(text).then(
        () => {
          const prev = btn.textContent;
          btn.textContent = currentLang === 'ar' ? 'تم' : 'OK';
          setTimeout(() => {
            btn.textContent = prev;
          }, 1200);
        },
        () => {},
      );
    });
  });

  setLanguage('ar');
})();
