// Generates the trial slides.
function trials() {
  // Shuffle the list of stimuli.
  var trials = _.shuffle([
    {name: "ND_UN_0_no-grid.png", num_doors: 1}, 
    {name: "ND_DX_0_no-grid.png", num_doors: 1},
    {name: "ND_DX_1_no-grid.png", num_doors: 1},
    {name: "ND_NX_0_no-grid.png", num_doors: 1},
    {name: "ND_NX_1_no-grid.png", num_doors: 1},
    {name: "ND_PX_0_no-grid.png", num_doors: 1},
    {name: "ND_PX_1_no-grid.png", num_doors: 1},
    {name: "DX_UN_0_no-grid.png", num_doors: 2},
    {name: "DX_DX_0_no-grid.png", num_doors: 2},
    {name: "DX_NX_0_no-grid.png", num_doors: 2},
    {name: "DX_PY_0_no-grid.png", num_doors: 2},
    {name: "NX_UN_0_no-grid.png", num_doors: 3},
    {name: "NX_DX_0_no-grid.png", num_doors: 3},
    {name: "NX_NX_0_no-grid.png", num_doors: 3},
    {name: "NX_PX_0_no-grid.png", num_doors: 3},
    {name: "PX_UN_0_no-grid.png", num_doors: 3},
    {name: "PX_DX_0_no-grid.png", num_doors: 3},
    {name: "PX_NX_0_no-grid.png", num_doors: 3},
    {name: "PX_PX_0_no-grid.png", num_doors: 3},
    {name: "UN_UN_0_no-grid.png", num_doors: 2},
    {name: "UN_DX_0_no-grid.png", num_doors: 2},
    {name: "UN_NX_0_no-grid.png", num_doors: 2},
    {name: "UN_PX_0_no-grid.png", num_doors: 2}
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
      "<table id=\"multi_slider_table_" + i + "\" class=\"slider_table\"></table>" +
      "<button onclick=\"_s.button()\">Continue</button>" +
      "<p class=\"trial_error\">Please adjust all sliders before continuing.</p>" +
      "</div>";
    $(".trial_slides").html(slides);
  }
}

// Sample unique names for the enforcer and the agent.
function get_characters(characters) {
    var shuffled_characters = _.shuffle(characters);

    return shuffled_characters[0].name;
}
