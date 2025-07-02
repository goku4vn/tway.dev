function gridCellDimensions() {
  const element = document.createElement("div");
  element.style.position = "fixed";
  element.style.height = "var(--line-height)";
  element.style.width = "1ch";
  document.body.appendChild(element);
  const rect = element.getBoundingClientRect();
  document.body.removeChild(element);
  return { width: rect.width, height: rect.height };
}

// Add padding to each media to maintain grid.
function adjustMediaPadding() {
  const cell = gridCellDimensions();

  function setHeightFromRatio(media, ratio) {
      const rect = media.getBoundingClientRect();
      const realHeight = rect.width / ratio;
      const diff = cell.height - (realHeight % cell.height);
      media.style.setProperty("padding-bottom", `${diff}px`);
  }

  function setFallbackHeight(media) {
      const rect = media.getBoundingClientRect();
      const height = Math.round((rect.width / 2) / cell.height) * cell.height;
      media.style.setProperty("height", `${height}px`);
  }

  function onMediaLoaded(media) {
    var width, height;
    switch (media.tagName) {
      case "IMG":
        width = media.naturalWidth;
        height = media.naturalHeight;
        break;
      case "VIDEO":
        width = media.videoWidth;
        height = media.videoHeight;
        break;
    }
    if (width > 0 && height > 0) {
      setHeightFromRatio(media, width / height);
    } else {
      setFallbackHeight(media);
    }
  }

  const medias = document.querySelectorAll("img, video");
  for (media of medias) {
    switch (media.tagName) {
      case "IMG":
        if (media.complete) {
          onMediaLoaded(media);
        } else {
          media.addEventListener("load", () => onMediaLoaded(media));
          media.addEventListener("error", function() {
              setFallbackHeight(media);
          });
        }
        break;
      case "VIDEO":
        switch (media.readyState) {
          case HTMLMediaElement.HAVE_CURRENT_DATA:
          case HTMLMediaElement.HAVE_FUTURE_DATA:
          case HTMLMediaElement.HAVE_ENOUGH_DATA:
            onMediaLoaded(media);
            break;
          default:
            media.addEventListener("loadeddata", () => onMediaLoaded(media));
            media.addEventListener("error", function() {
              setFallbackHeight(media);
            });
            break;
        }
        break;
    }
  }
}

adjustMediaPadding();
window.addEventListener("load", adjustMediaPadding);
window.addEventListener("resize", adjustMediaPadding);

function checkOffsets() {
  const ignoredTagNames = new Set([
    "THEAD",
    "TBODY",
    "TFOOT",
    "TR",
    "TD",
    "TH",
  ]);
  const cell = gridCellDimensions();
  const elements = document.querySelectorAll("body :not(.debug-grid, .debug-toggle)");
  for (const element of elements) {
    if (ignoredTagNames.has(element.tagName)) {
      continue;
    }
    const rect = element.getBoundingClientRect();
    if (rect.width === 0 && rect.height === 0) {
      continue;
    }
    const top = rect.top + window.scrollY;
    const left = rect.left + window.scrollX;
    const offset = top % (cell.height / 2);
    if(offset > 0) {
      element.classList.add("off-grid");
      console.error("Incorrect vertical offset for", element, "with remainder", top % cell.height, "when expecting divisible by", cell.height / 2);
    } else {
      element.classList.remove("off-grid");
    }
  }
}

const debugToggle = document.querySelector(".debug-toggle");
function onDebugToggle() {
  document.body.classList.toggle("debug", debugToggle.checked);
}
debugToggle.addEventListener("change", onDebugToggle);
onDebugToggle();

// Language Switching Functionality
function initLanguageSwitcher() {
  const langToggle = document.querySelector('.lang-toggle');
  const body = document.body;
  
  if (!langToggle) {
    // Retry if toggle not found (timing issue)
    setTimeout(initLanguageSwitcher, 100);
    return;
  }
  
  // Get saved language preference or default to English
  const savedLang = localStorage.getItem('preferred-language') || 'en';
  
  // Set initial language
  setLanguage(savedLang);
  
  // Add click listener to language toggle
  langToggle.addEventListener('change', (e) => {
    const selectedLang = e.target.checked ? 'vi' : 'en';
    setLanguage(selectedLang);
    localStorage.setItem('preferred-language', selectedLang);
  });
  
  function setLanguage(lang) {
    // Update body data attribute
    body.setAttribute('data-language', lang);
    
    // Update toggle state
    langToggle.checked = (lang === 'vi');
    
    // Process content sections to add language attributes
    processLanguageContent();
  }
  
  function processLanguageContent() {
    // First, hide all HR elements that are likely separators
    const allHRs = document.querySelectorAll('hr');
    allHRs.forEach(hr => {
      hr.style.display = 'none';
    });
    
    // Find all h2 elements that indicate language sections
    const h2Elements = document.querySelectorAll('h2');
    
    h2Elements.forEach(h2 => {
      const text = h2.textContent.trim();
      let lang = null;
      
      // Determine language based on header text
      if (text === 'English') {
        lang = 'en';
      } else if (text === 'Tiếng Việt') {
        lang = 'vi';
      }
      
      if (lang) {
        // Add language class to the header
        h2.classList.add('lang-content');
        h2.setAttribute('data-lang', lang);
        
        // Process following elements until next h2 or end of content
        let nextElement = h2.nextElementSibling;
        while (nextElement && nextElement.tagName !== 'H2') {
          // Skip HR elements entirely - they're already hidden above
          // Also skip debug-grid elements
          if (nextElement.tagName !== 'HR' && !nextElement.classList.contains('debug-grid')) {
            nextElement.classList.add('lang-content');
            nextElement.setAttribute('data-lang', lang);
          }
          nextElement = nextElement.nextElementSibling;
        }
      }
    });
  }
}

// Run immediately with retry logic
initLanguageSwitcher();

// Also keep the event listeners as backup
document.addEventListener('DOMContentLoaded', initLanguageSwitcher);
window.addEventListener('load', initLanguageSwitcher);
