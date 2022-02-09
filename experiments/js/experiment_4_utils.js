// Generates the list of trials.
function trials() {
  // Initialize the list of goal trials.
  var goal_trials = [
    {name: "DX_PX_0.png", num_doors: 2, furthest_corner: ["C"]},
    {name: "DX_UN_0.png", num_doors: 2, furthest_corner: ["A", "B", "C"]},
    {name: "NX_PX_0.png", num_doors: 3, furthest_corner: ["A", "C"]},
    {name: "NX_UN_0.png", num_doors: 3, furthest_corner: ["C"]},
    {name: "PX_PX_0.png", num_doors: 3, furthest_corner: ["C"]},
    {name: "PX_UN_0.png", num_doors: 3, furthest_corner: ["A"]},
    {name: "UN_PX_0.png", num_doors: 2, furthest_corner: ["A", "C"]},
    {name: "UN_UN_0.png", num_doors: 2, furthest_corner: ["A", "B", "C"]}
  ];

  // Initialize the list of door trials.
  var door_trials = [
    {name: "PX_DX_0.png", num_doors: 3, furthest_corner: ["C"]},
    {name: "PX_NX_0.png", num_doors: 3, furthest_corner: ["A", "B", "C"]},
    {name: "PX_PX_0.png", num_doors: 3, furthest_corner: ["C"]},
    {name: "PX_UN_0.png", num_doors: 3, furthest_corner: ["A"]},
    {name: "UN_DX_0.png", num_doors: 2, furthest_corner: ["C"]},
    {name: "UN_NX_0.png", num_doors: 2, furthest_corner: ["C"]},
    {name: "UN_PX_0.png", num_doors: 2, furthest_corner: ["A", "C"]},
    {name: "UN_UN_0.png", num_doors: 2, furthest_corner: ["A", "B", "C"]}
  ];

  return goal_trials.concat(door_trials);
}

// Embeds the trial slides.
function embed_slides(num_trials) {
  var slides = "";
  for (var i = 0; i < num_trials; i++) {
    // Embed the block transition slide.
    if (i == num_trials/2) {
      slides = slides + "<div class=\"slide\" id=\"transition\">" +
        "<div class=\"transition_instructions\"></div>" +
        "<button onclick=\"_s.button()\">Continue</button>" +
        "</div>";
    }

    // Embed the pre-trial slides.
    slides = slides + "<div class=\"slide\" id=\"trial" + (i+1+"a") + "\">" +
      "<div class=\"prompt\"></div>" +
      "<div class=\"stimulus\"></div>" +
      "<button onclick=\"_s.button()\">Continue</button>" +
      "</div>";

    // Embed the trial slides.
    slides = slides + "<div class=\"slide\" id=\"trial" + (i+1+"b") + "\">" +
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

// Extracts the URL parameters.
function get_url_parameters(parameter) {
  var url = window.location.search.substring(1);
  var url_variables = url.split("&");
  for (var i = 0; i < url_variables.length; i++) {
    var parameter_assignment = url_variables[i].split("=");
    if (parameter_assignment[0] == parameter) {
      return parameter_assignment[1];
    }
  }
  console.log("No parameters found.");
  return "no_params";
}
