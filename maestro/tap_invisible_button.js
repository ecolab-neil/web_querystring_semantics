console.log('🔍 Searching for Flutter invisible accessibility button...');
const fltSemantics = document.querySelectorAll('flt-semantics');
console.log('🔍 Found ${fltSemantics.length} semantic elements');
fltSemantics.forEach((el, i) => {
  console.log(`Element ${i}:`, el.outerHTML.substring(0, 200));
});

const selector = 'flt-semantics-placeholder[aria-label="Enable accessibility"]';
console.log(`Trying selector: "${selector}"`);

const invisibleButton = document.querySelector(selector);

try {
    invisibleButton.click();
    console.log('✅ Clicked button - accessibility enabled');
  } catch (error) {
    console.error('❌ Error clicking button:', error);

  }