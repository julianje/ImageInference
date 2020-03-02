// Generates the trial slides.
function trials() {
  // Shuffle the list of stimuli.
  var trials = _.shuffle([
    {name: "D1_0.png", furthest_corner: ["A", "C"]},
    {name: "D1_1.png", furthest_corner: ["C"]},
    {name: "D1_2.png", furthest_corner: ["A", "C"]},
    {name: "P1_0.png", furthest_corner: ["A", "C"]}, 
    {name: "P1_1.png", furthest_corner: ["A", "B"]},
    {name: "P1_2.png", furthest_corner: ["A"]},
    {name: "UN_0.png", furthest_corner: ["A", "B"]},
    {name: "UN_1.png", furthest_corner: ["A", "B", "C"]},
    {name: "UN_2.png", furthest_corner: ["C"]},
    {name: "P2_0.png", furthest_corner: ["A"]},
    {name: "P2_1.png", furthest_corner: ["B"]},
    {name: "P2_2.png", furthest_corner: ["A", "C"]},
    {name: "D2_0.png", furthest_corner: ["A", "C"]},
    {name: "D2_1.png", furthest_corner: ["A", "C"]},
    {name: "D2_2.png", furthest_corner: ["C"]}
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

// Sample unique names for the enforcer and the agent.
function get_characters(characters) {
    var shuffled_characters = _.shuffle(characters);

    return shuffled_characters[0].name;
}