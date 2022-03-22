var j = 0;
var wrong_objective = 0;

function make_slides(f) {
  var slides = {};

  slides.i0 = slide({
    name: "i0",
    start: function() {
      exp.startT = Date.now();
    }
  });

  // Set up the introduction slides.
  for (var i = 0; i < 11; i++) {
    slides["introduction_" + i] = slide({
      name: "introduction_" + i,
      start: function() {},
      button: function() { exp.go(); }
    });
  }

  // Set up the catch trial slide.
  slides.catch_trial = slide({
    name: "catch_trial",
    start: function() {
      $(".catch_error").hide();

      exp.question = [
        "How many corners is each person walking to?",
        "Do people always drop their cookie crumbs on their path to/from a corner?",
        "Do people get to choose which door they enter through?",
        "Do people leave the room out of the same door they entered or the door closest to them?",
        "Can people move diagonally?",
        "What color are the walls?"
      ];

      $(".catch_slide").html(
        "<p>" + exp.question[0] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_0\" value=\"0\"/>1</label>" +
        "<label><input type=\"radio\" name=\"question_0\" value=\"1\"/>2</label>" +
        "<label><input type=\"radio\" name=\"question_0\" value=\"2\"/>3</label>" +
        "<label><input type=\"radio\" name=\"question_0\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[1] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_1\" value=\"0\"/>Yes</label>" +
        "<label><input type=\"radio\" name=\"question_1\" value=\"1\"/>No</label>" +
        "<label><input type=\"radio\" name=\"question_1\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[2] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_2\" value=\"0\"/>Yes</label>" +
        "<label><input type=\"radio\" name=\"question_2\" value=\"1\"/>No</label>" +
        "<label><input type=\"radio\" name=\"question_2\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[3] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_3\" value=\"0\"/>Same door</label>" +
        "<label><input type=\"radio\" name=\"question_3\" value=\"1\"/>Closest door</label>" +
        "<label><input type=\"radio\" name=\"question_3\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[4] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_4\" value=\"0\"/>Yes</label>" +
        "<label><input type=\"radio\" name=\"question_4\" value=\"1\"/>No</label>" +
        "<label><input type=\"radio\" name=\"question_4\" value=\"-1\"/>Not sure</label>" +
        "</p>" +
        "<p>" + exp.question[5] + "</p>" +
        "<p>" +
        "<label><input type=\"radio\" name=\"question_5\" value=\"0\"/>White</label>" +
        "<label><input type=\"radio\" name=\"question_5\" value=\"1\"/>Gray</label>" +
        "<label><input type=\"radio\" name=\"question_5\" value=\"2\"/>Red</label>" +
        "<label><input type=\"radio\" name=\"question_5\" value=\"-1\"/>Not sure</label>" +
        "</p>"
      );
    },
    button: function() {
      exp.target_0 = $("input[name='question_0']:checked").val();
      exp.target_1 = $("input[name='question_1']:checked").val();
      exp.target_2 = $("input[name='question_2']:checked").val();
      exp.target_3 = $("input[name='question_3']:checked").val();
      exp.target_4 = $("input[name='question_4']:checked").val();
      exp.target_5 = $("input[name='question_5']:checked").val();

      // If a participant fails to answer every question.
      if ((exp.target_0 === undefined) || (exp.target_1 === undefined) || (exp.target_2 === undefined) ||
          (exp.target_3 === undefined) || (exp.target_4 === undefined) || (exp.target_5 === undefined)) {
        $(".catch_error").show();
      }

      // If a participant answers any question incorrectly.
      else if ((exp.target_0 != "0") || (exp.target_1 != "0") || (exp.target_2 != "1") ||
               (exp.target_3 != "0") || (exp.target_4 != "1") || (exp.target_5 != "1")) {
        // Stitch the participant responses together and send them as URL
        // parameters.
        exp.quiz = exp.target_0 + exp.target_1 + exp.target_2 + exp.target_3 +
            exp.target_4 + exp.target_5;
        window.location.replace("https://compdevlab.yale.edu/studies/lopez-brau/" +
          "ImageInference/experiments/experiment_4/fail.php" +
          "?PROLIFIC_PID=" + exp.id + "&QUIZ=" + exp.quiz);
      }
      else {
        exp.catch_trials.push({
          "question_0": exp.question[0],
          "target_0": exp.target_0,
          "question_1": exp.question[1],
          "target_1": exp.target_1,
          "question_2": exp.question[2],
          "target_2": exp.target_2,
          "question_3": exp.question[3],
          "target_3": exp.target_3,
          "question_4": exp.question[4],
          "target_4": exp.target_4,
          "question_5": exp.question[5],
          "target_5": exp.target_5,
          "quiz_attempts": exp.quiz_attempts
        });
        exp.go();
      }
    }
  });

  // Set up a pre-trial slide.
  function prestart() {
    if ((j < (exp.num_trials/2) && exp.prior_order == 0) || (j >= (exp.num_trials/2) && exp.prior_order == 1)) {
      $(".prompt").html("Consider the following new room and person. In their past " + exp.num_visits +
        " visits, this person visited <span style=\"font-family:Lucida Console;\">A</span> " +
        exp.prior_assignment[j][0] + " " + (exp.prior_assignment[j][0] == 1 ? "time" : "times") +
        ", <span style=\"font-family:Lucida Console;\">B</span> " +
        exp.prior_assignment[j][1] + " " + (exp.prior_assignment[j][1] == 1 ? "time" : "times") +
        ", and <span style=\"font-family:Lucida Console;\">C</span> " +
        exp.prior_assignment[j][2] + " " + (exp.prior_assignment[j][2] == 1 ? "time" : "times") + "."
      );
    } else {
      if (exp.num_doors[j] == 2) {
        $(".prompt").html("Consider the following new room and person. In their past " + exp.num_visits +
          " visits, this person walked through <span style=\"font-family:Lucida Console;\">1</span> " +
          exp.prior_assignment[j][0] + " " + (exp.prior_assignment[j][0] == 1 ? "time" : "times") +
          " and <span style=\"font-family:Lucida Console;\">2</span> " +
          exp.prior_assignment[j][1] + " " + (exp.prior_assignment[j][1] == 1 ? "time" : "times") + "."
        );
      } else {
        $(".prompt").html("Consider the following new room and person. In their past " + exp.num_visits +
          " visits, this person walked through <span style=\"font-family:Lucida Console;\">1</span> " +
          exp.prior_assignment[j][0] + " " + (exp.prior_assignment[j][0] == 1 ? "time" : "times") +
          ", <span style=\"font-family:Lucida Console;\">2</span> " +
          exp.prior_assignment[j][1] + " " + (exp.prior_assignment[j][1] == 1 ? "time" : "times") +
          ", and <span style=\"font-family:Lucida Console;\">3</span> " +
          exp.prior_assignment[j][2] + " " + (exp.prior_assignment[j][2] == 1 ? "time" : "times") + "."
        );
      }
    }
    $(".stimulus").html(
      "<div style=\"display:grid;grid-template-columns:1fr;position:relative;justify-items:center;\">" +
      "<img style=\"height:250px;width:250px;grid-row:1;grid-column:1;z-index:0;\" " +
      "src=\"../stimuli/experiment_4/" + exp.trials[j] + "\"></img>" +
      "<img style=\"height:250px;width:250px;grid-row:1;grid-column:1;z-index:1;\" " +
      "src=\"../stimuli/experiment_4/" + exp.layers[j] + "\"></img>" +
      "</div>"
    );
  }

  // Set up a pre-trial slide button functionality.
  function prebutton() {
    exp.go();
  }

  // Set up a trial slide.
  function start() {
    $(".trial_error").hide();
    $(".objective_error").hide();
    $(".slider_row").remove();

    if ((j < (exp.num_trials/2) && exp.prior_order == 0) || (j >= (exp.num_trials/2) && exp.prior_order == 1)) {
      $(".prompt").html("Consider the following new room and person. In their past " + exp.num_visits +
        " visits, this person visited <span style=\"font-family:Lucida Console;\">A</span> " +
        exp.prior_assignment[j][0] + " " + (exp.prior_assignment[j][0] == 1 ? "time" : "times") +
        ", <span style=\"font-family:Lucida Console;\">B</span> " +
        exp.prior_assignment[j][1] + " " + (exp.prior_assignment[j][1] == 1 ? "time" : "times") +
        ", and <span style=\"font-family:Lucida Console;\">C</span> " +
        exp.prior_assignment[j][2] + " " + (exp.prior_assignment[j][2] == 1 ? "time" : "times") + "."
      );
    } else {
      if (exp.num_doors[j] == 2) {
        $(".prompt").html("Consider the following new room and person. In their past " + exp.num_visits +
          " visits, this person walked through <span style=\"font-family:Lucida Console;\">1</span> " +
          exp.prior_assignment[j][0] + " " + (exp.prior_assignment[j][0] == 1 ? "time" : "times") +
          " and <span style=\"font-family:Lucida Console;\">2</span> " +
          exp.prior_assignment[j][1] + " " + (exp.prior_assignment[j][1] == 1 ? "time" : "times") + "."
        );
      } else {
        $(".prompt").html("Consider the following new room and person. In their past " + exp.num_visits +
          " visits, this person walked through <span style=\"font-family:Lucida Console;\">1</span> " +
          exp.prior_assignment[j][0] + " " + (exp.prior_assignment[j][0] == 1 ? "time" : "times") +
          ", <span style=\"font-family:Lucida Console;\">2</span> " +
          exp.prior_assignment[j][1] + " " + (exp.prior_assignment[j][1] == 1 ? "time" : "times") +
          ", and <span style=\"font-family:Lucida Console;\">3</span> " +
          exp.prior_assignment[j][2] + " " + (exp.prior_assignment[j][2] == 1 ? "time" : "times") + "."
        );
      }
    }
    $(".stimulus").html(
      "<div " +
      "style=\"display:grid;grid-template-columns:1fr 1fr;position:relative;\">" +
      "<img style=\"height:250px;width:250px;grid-row:1;grid-column:1;z-index:0;justify-self:end;margin-right:25px;\" " +
      "src=\"../stimuli/experiment_4/" + exp.trials[j] + "\"></img>" +
      "<img style=\"height:250px;width:250px;grid-row:1;grid-column:1;z-index:1;justify-self:end;margin-right:25px;\" " +
      "src=\"../stimuli/experiment_4/" + exp.layers[j] + "\"></img>" +
      "<div align=\"center\" style=\"grid-row:1;grid-column:2;justify-self:start;margin-left:25px;\">" +
      "<p style=\"font-size:16px;font-weight:bold;\">Which corner is the farthest walk from Door 1?<br>" +
      "If there is more than one correct answer, just<br>" +
      "choose one of them.</p>" +
      "<label>" +
      "<input type=\"radio\" name=\"objective\" value=\"A\"/ style=\"margin: 0 5px 0 0;\">" +
      "<img src=\"../stimuli/experiment_4/A.png\" alt=\"\" style=\"width:35px;height:auto;\">" +
      "</label>" +
      "<label><input type=\"radio\" name=\"objective\" value=\"B\"/>" +
      "<img src=\"../stimuli/experiment_4/B.png\" alt=\"\" style=\"width:35px;height:auto;\">" +
      "</label>" +
      "<label><input type=\"radio\" name=\"objective\" value=\"C\"/>" +
      "<img src=\"../stimuli/experiment_4/C.png\" alt=\"\" style=\"width:35px;height:auto;\">" +
      "</label>" +
      "</div>" +
      "</div>"
    );

    exp.questions = [
      "Which door did they come from?",
      "Which corner is the person going for?"
    ];

    $("#multi_slider_table_" + j).append(
      "<tr>" +
      (exp.num_doors[j] > 1 ?
        "<th></th>" +
        "<th colspan=\"2\">" + exp.questions[0] + "</th>" : "") +
      "<th></th>" +
      "<th colspan=\"2\">" + exp.questions[1] + "</th>" +
      "<tr>" +
      (exp.num_doors[j] > 1 ?
        "<td></td>" +
        "<td style=\"text-align:left;\">definitely not</td>" +
        "<td style=\"text-align:right;\">definitely</td>" +
        "<td width=\"100px\"></td>" : "<td></td>") +
      "<td style=\"text-align:left;\">definitely not</td>" +
      "<td style=\"text-align:right;\">definitely</td>" +
      "</tr>" +
      "<tr class=\"slider_row\">" +
      (exp.num_doors[j] > 1 ?
        "<td class=\"slider_target\"><img src=\"../stimuli/experiment_4/1.png\" " +
        "alt=\"\" style=\"width:35px;height:auto;\"></td>" +
        "<td colspan=\"2\">" +
        "<div id=\"door_0\" class=\"slider\">-------[ ]--------</div></td>" : "") +
      "<td class=\"slider_target\"><img src=\"../stimuli/experiment_4/A.png\" " +
      "alt=\"\" style=\"width:35px;height:auto;\"></td>" +
      "<td colspan=\"2\">" +
      "<div id=\"goal_0\" class=\"slider\">-------[ ]--------</div>" +
      "</td>" +
      "</tr>" +
      "<tr>" +
      (exp.num_doors[j] > 1 ?
        "<td></td>" +
        "<td style=\"text-align:left;\">definitely not</td>" +
        "<td style=\"text-align:right;\">definitely</td>" : "") +
      "<td></td>" +
      "<td style=\"text-align:left;\">definitely not</td>" +
      "<td style=\"text-align:right;\">definitely</td>" +
      "</tr>" +
      "<tr class=\"slider_row\">" +
      (exp.num_doors[j] > 1 ?
        "<td class=\"slider_target\"><img src=\"../stimuli/experiment_4/2.png\" " +
        "alt=\"\" style=\"width:35px;height:auto;\"></td>" +
        "<td colspan=\"2\">" +
        "<div id=\"door_1\" class=\"slider\">-------[ ]--------</div></td>" : "") +
      "<td class=\"slider_target\"><img src=\"../stimuli/experiment_4/B.png\" " +
      "alt=\"\" style=\"width:35px;height:auto;\"></td>" +
      "<td colspan=\"2\">" +
      "<div id=\"goal_1\" class=\"slider\">-------[ ]--------</div>" +
      "</td>" +
      "</tr>" +
      "<tr>" +
      (exp.num_doors[j] > 2 ?
        "<td></td>" +
        "<td style=\"text-align:left;\">definitely not</td>" +
        "<td style=\"text-align:right;\">definitely</td>" :
        (exp.num_doors[j] == 2 ? "<td></td><td colspan=\"2\"></td>" : "")) +
      "<td></td>" +
      "<td style=\"text-align:left;\">definitely not</td>" +
      "<td style=\"text-align:right;\">definitely</td>" +
      "</tr>" +
      "<tr class=\"slider_row\">" +
      (exp.num_doors[j] > 2 ?
        "<td class=\"slider_target\"><img src=\"../stimuli/experiment_4/3.png\" " +
        "alt=\"\" style=\"width:35px;height:auto;\"></td>" +
        "<td colspan=\"2\">" +
        "<div id=\"door_2\" class=\"slider\">-------[ ]--------</div></td>" :
        (exp.num_doors[j] == 2 ? "<td></td><td colspan=\"2\"></td>" : "")) +
      "<td class=\"slider_target\"><img src=\"../stimuli/experiment_4/C.png\" " +
      "alt=\"\" style=\"width:35px;height:auto;\"></td>" +
      "<td colspan=\"2\">" +
      "<div id=\"goal_2\" class=\"slider\">-------[ ]--------</div>" +
      "</td>" +
      "</tr>"
    );
    utils.match_row_height("#multi_slider_table_" + j, ".slider_target");
    utils.make_slider("#door_0", make_slider_callback(0));
    utils.make_slider("#goal_0", make_slider_callback(1));
    utils.make_slider("#door_1", make_slider_callback(2));
    utils.make_slider("#goal_1", make_slider_callback(3));
    utils.make_slider("#door_2", make_slider_callback(4));
    utils.make_slider("#goal_2", make_slider_callback(5));

    exp.sliderPost = [];
    if (exp.num_doors[j] == 1) {
      exp.sliderPost[0] = -1;
      exp.sliderPost[2] = -1;
      exp.sliderPost[4] = -1;
    }
    else if (exp.num_doors[j] == 2) {
      exp.sliderPost[4] = -1;
    }
  }

  // Set up a trial slide button functionality.
  function button() {
    exp.objective = $("input[name='objective']:checked").val();
    incorrect = true;
    for (i = 0; i < exp.furthest_corner[j].length; i++) {
      if (exp.objective == exp.furthest_corner[j][i]) {
        incorrect = false;
      }
    }
    if ((exp.sliderPost[0] === undefined) || (exp.sliderPost[1] === undefined) ||
        (exp.sliderPost[2] === undefined) || (exp.sliderPost[3] === undefined) ||
        (exp.sliderPost[4] === undefined) || (exp.sliderPost[5] === undefined) ||
        (exp.objective === undefined)) {
        $(".trial_error").show();
    }
    else if (incorrect) {
      $(".trial_error").hide();
      $(".objective_error").show();
      wrong_objective++;
    }
    else {
        exp.data_trials.push({
          "trial_num": j + 1,
          "map": exp.trials[j],
          "prior": exp.layers[j],
          "1": exp.sliderPost[0],
          "2": exp.sliderPost[2],
          "3": exp.sliderPost[4],
          "A": exp.sliderPost[1],
          "B": exp.sliderPost[3],
          "C": exp.sliderPost[5],
          "wrong_objective": wrong_objective
        });
        j++;
        wrong_objective = 0;
        exp.go();
    }
  }

  function make_slider_callback(i) {
    return function(event, ui) { exp.sliderPost[i] = ui.value; };
  }

  // Stitches together all of the pre-trial slides.
  for (var i = 1; i <= exp.num_trials; i++) {
    slides["trial" + i + "a"] = slide({
      name: "trial" + i + "a",
      start: prestart,
      button: prebutton
    });
  }

  // Stitches together all of the trial slides.
  for (var i = 1; i <= exp.num_trials; i++) {
    slides["trial" + i + "b"] = slide({
      name: "trial" + i + "b",
      start: start,
      button: button
    });
  }

  slides.transition = slide({
    name: "transition",
    start: function() {
      $(".transition_instructions").html("<p>You're halfway done. Great job so far! " +
        exp.transition_instructions[exp.prior_order] + "</p>");
    },
    button: function() { exp.go(); }
  });

  slides.subj_info = slide({
    name: "subj_info",
    start: function() {},
    submit: function(e) {
      exp.subj_data = {
        "language": $("#language").val(),
        "asses": $("input[name='assess']:checked").val(),
        "age": $("#age").val(),
        "gender": $("#gender").val(),
        "education": $("#education").val(),
        "problems": $("#problems").val(),
        "comments": $("#comments").val()
      };
      exp.go();
    }
  });

  slides.thanks = slide({
    name: "thanks",
    start: function() {
      exp.data = {
        "id": exp.id,
        "trials": exp.data_trials,
        "catch_trials": exp.catch_trials,
        "system": exp.system,
        "subject_information": exp.subj_data,
        "time_in_minutes": (Date.now() - exp.startT) / 60000
      };
      $(".end").html(
        "<form method=\"post\" action=\"experiment_4/end.php\">" +
        "<input type=\"hidden\" name=\"data\" value=\'" +
        JSON.stringify(exp.data).replace(/'/g, "") + "\' />" +
        "<button type=\"submit\">Finish Experiment</button>" +
        "</form>"
      );
    }
  });

  return slides;
}

function init() {
  // Read in the participant ID.
  exp.id = get_url_parameters("PROLIFIC_PID");

  // Read in this participant's quiz attempts.
  exp.quiz_attempts = quiz_attempts;

  // Initialize the task duration and payment amount.
  exp.time = 20;
  $(".time").html(exp.time);
  exp.rate = 12.00;
  $(".payment").html("$" + (exp.time/60*exp.rate).toPrecision(3));

  // Set up the basic trial information.
  trials = trials();
  exp.trials = _.pluck(trials, "name");
  exp.furthest_corner = _.pluck(trials, "furthest_corner");
  exp.num_doors = _.pluck(trials, "num_doors");
  exp.num_trials = exp.trials.length;
  $(".num_trials").html(exp.num_trials);
  exp.num_visits = 9;
  $(".num_visits").html(exp.num_visits);
  exp.latest_visit = 10;
  $(".latest_visit").html(exp.latest_visit);
  exp.prior_instructions = [
    "In the first section, this information will be about how often they walked to a particular corner. " +
    "In the second section, this information will be about how often they walked through a particular door.",
    "In the first section, this information will be about how often they walked through a particular door. " +
    "In the second section, this information will be about how often they walked to a particular corner."
  ];
  exp.transition_instructions = [
    "In the next section, you will now see additional information about how often someone walked through a particular door.",
    "In the next section, you will now see additional information about how often someone walked to a particular corner.",
  ];

  // Assign each trial with a prior distribution.
  exp.condition_assignment = condition_assignment.replace(/\r\n/g, "").split(",");
  exp.prior_order = exp.condition_assignment.pop();
  exp.prior_assignment = exp.condition_assignment;
  $(".prior_manipulation_order").html(exp.prior_instructions[exp.prior_order]);
  exp.layers = [];
  for (var i = 0; i < exp.num_trials; i++) {
    if (i < exp.num_trials/2) {
      exp.layers.push("goals-"+exp.prior_assignment[i]+".png");
    } else {
      exp.layers.push(exp.trials[i].replace(/.png/g, "_doors-"+exp.prior_assignment[i]+".png"));
    }
  }

  // Swap trial blocks according to the prior manipulation order, if needed.
  if (exp.prior_order == 1) {
    exp.furthest_corner = exp.furthest_corner.slice(exp.num_trials/2, exp.num_trials).concat(
      exp.furthest_corner.slice(0, exp.num_trials/2));
    exp.num_doors = exp.num_doors.slice(exp.num_trials/2, exp.num_trials).concat(
      exp.num_doors.slice(0, exp.num_trials/2));
    exp.prior_assignment = exp.prior_assignment.slice(exp.num_trials/2, exp.num_trials).concat(
      exp.prior_assignment.slice(0, exp.num_trials/2));
    exp.trials = exp.trials.slice(exp.num_trials/2, exp.num_trials).concat(
      exp.trials.slice(0, exp.num_trials/2));
    exp.layers = exp.layers.slice(exp.num_trials/2, exp.num_trials).concat(
      exp.layers.slice(0, exp.num_trials/2));
  }

  // Randomize the trials in each trial block.
  var indices = [];
  for (var i = 0; i < exp.num_trials; i++) {
    indices.push(i);
  }
  var random_indices = _.shuffle(indices.slice(0, exp.num_trials/2)).concat(
    _.shuffle(indices.slice(exp.num_trials/2, exp.num_trials)));
  exp.furthest_corner = random_indices.map(function(index){return exp.furthest_corner[index]});
  exp.num_doors = random_indices.map(function(index){return exp.num_doors[index]});
  exp.prior_assignment = random_indices.map(function(index){return exp.prior_assignment[index]});
  exp.trials = random_indices.map(function(index){return exp.trials[index]});
  exp.layers = random_indices.map(function(index){return exp.layers[index]});
  exp.data_trials = [];
  exp.catch_trials = [];

  // Get user system specs.
  exp.system = {
    Browser: BrowserDetect.browser,
    OS: BrowserDetect.OS,
    screenH: screen.height,
    screenUH: exp.height,
    screenW: screen.width,
    screenUW: exp.width
  };

  // Stitch together the blocks of the experiment.
  exp.structure = [
    "i0",
    "introduction_0",
    "introduction_1",
    "introduction_2",
    "introduction_3",
    "introduction_4",
    "introduction_5",
    "introduction_6",
    "introduction_7",
    "introduction_8",
    "introduction_9",
    "introduction_10",
    "catch_trial"
  ];
  for (var k = 1; k <= exp.num_trials; k++) {
    exp.structure.push("trial" + k + "a");
    exp.structure.push("trial" + k + "b");
    if (k == exp.num_trials/2) {
      exp.structure.push("transition");
    }
  }
  exp.structure.push("subj_info");
  exp.structure.push("thanks");

  // Make and embed the slides.
  exp.slides = make_slides(exp);
  embed_slides(exp.num_trials);

  // Get the length of the experiment.
  exp.nQs = utils.get_exp_length();

  // Hide the slides.
  $(".slide").hide();

  // Make sure Turkers have accepted HIT (or you're not in MTurk).
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    }
    else {
      $("#start_button").click(function() { $("#mustaccept").show(); });
      exp.go();
    }
  });

  // Launch the slides.
  exp.go();
}
