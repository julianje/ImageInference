// Generates the trial slides.
function trials() {
  // Shuffle the list of stimuli.
  var trials = _.shuffle([
    {name: "DX_DX_0.png", num_doors: 2, furthest_corner: ["C"]},
    {name: "DX_NX_0.png", num_doors: 2, furthest_corner: ["A"]},
    {name: "DX_PX_0.png", num_doors: 2, furthest_corner: ["C"]},
    {name: "DX_UN_0.png", num_doors: 2, furthest_corner: ["A", "B", "C"]}, 
    {name: "ND_DX_0.png", num_doors: 1, furthest_corner: ["A", "C"]},
    {name: "ND_DX_1.png", num_doors: 1, furthest_corner: ["C"]},
    {name: "ND_NX_0.png", num_doors: 1, furthest_corner: ["A", "C"]},
    {name: "ND_NX_1.png", num_doors: 1, furthest_corner: ["C"]},
    {name: "ND_PX_0.png", num_doors: 1, furthest_corner: ["C"]},
    {name: "ND_PX_1.png", num_doors: 1, furthest_corner: ["B", "C"]},
    {name: "ND_UN_0.png", num_doors: 1, furthest_corner: ["A", "B"]},
    {name: "NX_DX_0.png", num_doors: 3, furthest_corner: ["A", "C"]},
    {name: "NX_NX_0.png", num_doors: 3, furthest_corner: ["C"]},
    {name: "NX_PX_0.png", num_doors: 3, furthest_corner: ["A", "C"]},
    {name: "NX_UN_0.png", num_doors: 3, furthest_corner: ["C"]},
    {name: "PX_DX_0.png", num_doors: 3, furthest_corner: ["C"]},
    {name: "PX_NX_0.png", num_doors: 3, furthest_corner: ["A", "B", "C"]},
    {name: "PX_PX_0.png", num_doors: 3, furthest_corner: ["C"]},
    {name: "PX_UN_0.png", num_doors: 3, furthest_corner: ["A"]},
    {name: "UN_DX_0.png", num_doors: 2, furthest_corner: ["C"]},
    {name: "UN_NX_0.png", num_doors: 2, furthest_corner: ["C"]},
    {name: "UN_PX_0.png", num_doors: 2, furthest_corner: ["A", "C"]},
    {name: "UN_UN_0.png", num_doors: 2, furthest_corner: ["A", "B", "C"]}
  ])

  return trials;
}

// Embeds the trial slides.
function embed_slides(num_trials) {
  var slides = "";
  for (var i = 0; i < num_trials; i++) {
    slides = slides + "<div class=\"slide\" id=\"trial" + (i+1) + "\">" + 
      "<div class=\"prompt\"></div>" +
      "<div class=\"stimulus\"></div>" +
      "<table style=\"margin-bottom:10px;\" id=\"multi_slider_table_" + i + "\" class=\"slider_table\"></table>" +
      "<button onclick=\"_s.button()\">Continue</button>" +
      "<p class=\"trial_error\">Please answer all questions before continuing.</p>" +
      "<p class=\"objective_error\">You answered something incorrectly. Please pay attention and try again!</p>" +
      "</div>";
    $(".trial_slides").html(slides);
  }
}