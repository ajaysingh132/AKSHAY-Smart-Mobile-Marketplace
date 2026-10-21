/* Maa Sharda General Marketplace — demo frontend only.
   Product records are illustrative. Connect a secure database before real operations. */
const SUPPORT_WHATSAPP = "919098682878";
const products = [
  {id:"DEMO-001",name:"फास्ट चार्जर",category:"मोबाइल",icon:"🔌",price:199,unit:"प्रति नग",min:1,mode:["retail","wholesale"],note:"मोबाइल एक्सेसरीज़ • डेमो"},
  {id:"DEMO-002",name:"मोबाइल कवर",category:"मोबाइल",icon:"📱",price:60,unit:"प्रति नग से",min:10,mode:["wholesale"],note:"मॉडल और उपलब्धता सप्लायर से जाँचें"},
  {id:"DEMO-003",name:"चूड़ी सेट",category:"मनिहारी",icon:"💍",price:45,unit:"प्रति सेट से",min:12,mode:["wholesale","retail"],note:"डिजाइन और आकार के अनुसार कीमत बदल सकती है"},
  {id:"DEMO-004",name:"बिंदी पैक",category:"मनिहारी",icon:"✨",price:10,unit:"प्रति पैक से",min:20,mode:["wholesale","retail"],note:"मनिहारी • डेमो"},
  {id:"DEMO-005",name:"कॉस्मेटिक पाउच",category:"कॉस्मेटिक्स",icon:"💄",price:75,unit:"प्रति नग से",min:6,mode:["wholesale","retail"],note:"ब्रांड और विवरण की पुष्टि आवश्यक"},
  {id:"DEMO-006",name:"पर्सनल केयर किट",category:"निजी उपयोग",icon:"🧴",price:120,unit:"प्रति किट से",min:5,mode:["wholesale","retail"],note:"केवल उदाहरण; वास्तविक उत्पाद सूची नहीं"},
  {id:"DEMO-007",name:"प्लास्टिक स्टोरेज डिब्बा",category:"घरेलू सामान",icon:"🧺",price:55,unit:"प्रति नग से",min:12,mode:["wholesale","retail"],note:"घरेलू उपयोग • डेमो"},
  {id:"DEMO-008",name:"किचन बर्तन सेट",category:"किचन",icon:"🍽️",price:250,unit:"प्रति सेट से",min:4,mode:["wholesale","retail"],note:"सामग्री और मात्रा सप्लायर से जाँचें"},
  {id:"DEMO-009",name:"नोटबुक पैक",category:"स्टेशनरी",icon:"📚",price:180,unit:"प्रति पैक से",min:5,mode:["wholesale","retail"],note:"स्टेशनरी • डेमो"},
  {id:"DEMO-010",name:"गिफ्ट आइटम",category:"गिफ्ट",icon:"🎁",price:90,unit:"प्रति नग से",min:6,mode:["wholesale","retail"],note:"डिजाइन और उपलब्धता की पुष्टि आवश्यक"},
  {id:"DEMO-013",name:"स्कूल और कॉलेज की पुस्तकें",category:"बुक डिपो एवं प्रकाशन",icon:"📚",price:150,unit:"प्रति पुस्तक से",min:1,mode:["wholesale","retail"],note:"NCERT, पाठ्यपुस्तकें, संदर्भ पुस्तकें और गाइड • डेमो"},
  {id:"DEMO-014",name:"प्रतियोगी परीक्षा पुस्तकें",category:"बुक डिपो एवं प्रकाशन",icon:"📖",price:220,unit:"प्रति पुस्तक से",min:1,mode:["wholesale","retail"],note:"UPSC, राज्य PSC, SSC, रेलवे, बैंकिंग और अन्य परीक्षाएँ • डेमो"},
  {id:"DEMO-015",name:"धार्मिक और आध्यात्मिक पुस्तकें",category:"बुक डिपो एवं प्रकाशन",icon:"🕉️",price:120,unit:"प्रति पुस्तक से",min:1,mode:["wholesale","retail"],note:"वेद, उपनिषद, गीता, रामायण, पूजा-पाठ और अन्य • डेमो"},
  {id:"DEMO-016",name:"साहित्य और उपन्यास",category:"बुक डिपो एवं प्रकाशन",icon:"📕",price:180,unit:"प्रति पुस्तक से",min:1,mode:["wholesale","retail"],note:"हिंदी व अन्य भाषाओं का साहित्य, कहानी, कविता और उपन्यास • डेमो"},
  {id:"DEMO-017",name:"बच्चों की पुस्तकें",category:"बुक डिपो एवं प्रकाशन",icon:"🧒",price:90,unit:"प्रति पुस्तक से",min:1,mode:["wholesale","retail"],note:"चित्र पुस्तकें, बाल साहित्य, गतिविधि पुस्तकें और शुरुआती शिक्षा • डेमो"},
  {id:"DEMO-018",name:"सामान्य ज्ञान और शब्दकोश",category:"बुक डिपो एवं प्रकाशन",icon:"📗",price:160,unit:"प्रति पुस्तक से",min:1,mode:["wholesale","retail"],note:"सामान्य ज्ञान, शब्दकोश, विश्वकोश और संदर्भ सामग्री • डेमो"},
  {id:"DEMO-019",name:"कृषि, व्यवसाय और तकनीकी पुस्तकें",category:"बुक डिपो एवं प्रकाशन",icon:"📘",price:250,unit:"प्रति पुस्तक से",min:1,mode:["wholesale","retail"],note:"कृषि, कंप्यूटर, विज्ञान, कौशल, प्रबंधन और व्यावसायिक शिक्षा • डेमो"},
  {id:"DEMO-011",name:"ईयरबड्स",category:"मोबाइल",icon:"🎧",price:350,unit:"प्रति नग से",min:5,mode:["wholesale","retail"],note:"स्पेसिफिकेशन और वारंटी सत्यापित करें"},
  {id:"DEMO-012",name:"सफाई उपयोगी सामान",category:"घरेलू सामान",icon:"🧽",price:35,unit:"प्रति नग से",min:12,mode:["wholesale","retail"],note:"घरेलू उपयोग • डेमो"}
];
let selectedMode = "all";
let selectedCategory = "";
const grid = document.getElementById("productGrid");
const searchInput = document.getElementById("searchInput");
const emptyState = document.getElementById("emptyState");
const money = value => "₹" + value.toLocaleString("en-IN");
function renderProducts(){
  const term = (searchInput.value || "").trim().toLocaleLowerCase("hi");
  const filtered = products.filter(p => {
    const matchesTerm = !term || (p.name+" "+p.category+" "+p.note).toLocaleLowerCase("hi").includes(term);
    const matchesMode = selectedMode === "all" || p.mode.includes(selectedMode);
    const matchesCategory = !selectedCategory || p.category === selectedCategory;
    return matchesTerm && matchesMode && matchesCategory;
  });
  grid.innerHTML = filtered.map(p => {
    const modeLabel = p.mode.includes("wholesale") && p.mode.includes("retail") ? "होलसेल + फुटकर" : p.mode.includes("wholesale") ? "होलसेल" : "फुटकर";
    const message = encodeURIComponent("नमस्ते, माँ शारदा जनरल मार्केटप्लेस पर इस डेमो उत्पाद के बारे में जानकारी चाहिए: "+p.name+" ("+p.id+"). कृपया वास्तविक उपलब्धता, कीमत, न्यूनतम ऑर्डर और डिलीवरी की जानकारी दें।");
    return '<article class="product-card"><div class="product-icon" aria-hidden="true">'+p.icon+'</div><span class="product-type">'+p.category+' • '+modeLabel+'</span><h3>'+p.name+'</h3><p>'+p.note+'</p><div class="product-price">'+money(p.price)+'</div><div class="product-meta">'+p.unit+' · न्यूनतम मात्रा: '+p.min+'</div><div class="product-actions"><a class="button" href="https://wa.me/'+SUPPORT_WHATSAPP+'?text='+message+'" target="_blank" rel="noopener">पूछताछ</a></div></article>';
  }).join("");
  emptyState.hidden = filtered.length > 0;
}
document.querySelectorAll("[data-filter]").forEach(button => button.addEventListener("click", () => {
  selectedMode = button.dataset.filter;
  document.querySelectorAll("[data-filter]").forEach(b => b.classList.toggle("active", b === button));
  renderProducts();
}));
document.querySelectorAll(".category-card").forEach(button => button.addEventListener("click", () => {
  selectedCategory = button.dataset.category;
  searchInput.value = "";
  document.getElementById("products").scrollIntoView({behavior:"smooth"});
  renderProducts();
}));
document.getElementById("searchButton").addEventListener("click", () => { selectedCategory = ""; renderProducts(); document.getElementById("products").scrollIntoView({behavior:"smooth"}); });
searchInput.addEventListener("keydown", e => { if(e.key === "Enter"){ selectedCategory = ""; renderProducts(); document.getElementById("products").scrollIntoView({behavior:"smooth"}); } });
document.getElementById("sellerForm").addEventListener("submit", event => {
  event.preventDefault();
  const data = new FormData(event.currentTarget);
  const text = [
    "माँ शारदा जनरल मार्केटप्लेस — व्यापारी पंजीकरण आवेदन",
    "फर्म: "+data.get("business"),
    "संपर्क व्यक्ति: "+data.get("owner"),
    "मोबाइल: "+data.get("phone"),
    "स्थान: "+data.get("location"),
    "श्रेणी: "+data.get("category"),
    "बिक्री प्रकार: "+data.get("salesType"),
    "कृपया मेरे आवेदन की अगली प्रक्रिया बताएँ।"
  ].join("\n");
  window.open("https://wa.me/"+SUPPORT_WHATSAPP+"?text="+encodeURIComponent(text), "_blank", "noopener");
});
document.getElementById("year").textContent = new Date().getFullYear();
renderProducts();
/* Accessible Book Depot dropdown and category shortcuts */
const bookDropdown = document.querySelector(".nav-dropdown");
const bookDropdownToggle = document.querySelector(".nav-dropdown-toggle");
if (bookDropdown && bookDropdownToggle) {
  bookDropdownToggle.addEventListener("click", () => {
    const open = bookDropdown.classList.toggle("open");
    bookDropdownToggle.setAttribute("aria-expanded", String(open));
  });
  document.addEventListener("click", event => {
    if (!bookDropdown.contains(event.target)) {
      bookDropdown.classList.remove("open");
      bookDropdownToggle.setAttribute("aria-expanded", "false");
    }
  });
  document.addEventListener("keydown", event => {
    if (event.key === "Escape") {
      bookDropdown.classList.remove("open");
      bookDropdownToggle.setAttribute("aria-expanded", "false");
      bookDropdownToggle.focus();
    }
  });
  bookDropdown.querySelectorAll("a").forEach(link => link.addEventListener("click", () => {
    bookDropdown.classList.remove("open");
    bookDropdownToggle.setAttribute("aria-expanded", "false");
  }));
}
document.querySelectorAll("[data-book-search]").forEach(button => button.addEventListener("click", () => {
  selectedCategory = "बुक डिपो एवं प्रकाशन";
  searchInput.value = button.dataset.bookSearch.split(/\s+/)[0];
  document.getElementById("products").scrollIntoView({behavior:"smooth"});
  renderProducts();
}));
