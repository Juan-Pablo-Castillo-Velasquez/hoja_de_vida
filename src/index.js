document.getElementById("btn_download").addEventListener("click", () => {
    var element = document.getElementById("contenidoDescargable");
  const opt = {
  margin: 0.2,
  filename: 'hoja_de_vida_juan_pablo_castillo_velasquez.pdf',
  image: { type: 'jpeg', quality: 0.98 },
  html2canvas: { scale: 3 },
  jsPDF: { unit: 'in', format: 'a3', orientation: 'portrait' }
};

    html2pdf().set(opt).from(element).save();   
})