<?php
// Start/resume the session.
session_start();

// If this is a previous session, reload the PID and quiz attempts;
// otherwise, set them and generate the condition assignment.
if (isset($_SESSION["pid"])) {
  $quiz_attempts = $_SESSION["quiz_attempts"];
  $condition_assignment = $_SESSION["condition_assignment"];
  if ($quiz_attempts >= 2) {
    die("Sorry, you failed the quiz too many times. You are not eligible for this study.");
  }
} else {
  $pid = htmlspecialchars($_GET["PROLIFIC_PID"]);
  $quiz_attempts = 0;
  $_SESSION["pid"] = $pid;
  $_SESSION["quiz_attempts"] = $quiz_attempts;

  // Set up the number of participants.
  $num_participants = 160;

  // Set up the path to the experiment files.
  $experiment_dir = "/var/www/html/studies/lopez-brau/ImageInference/experiments/experiment_4/";

  // Set up the path to where the assigned condition indices are stored.
  $data_dir = $experiment_dir . "data/";

  // Find the earliest condition index available.
  $files = scandir($data_dir);
  for ($i = 0; $i < $num_participants; $i++) {
    $filename = $i . ".txt";

    // If the current condition index doesn't exist in the directory, try to
    // open it.
    if (!in_array($filename, $files)) {
      # Try to open the current condition index.
      $file = fopen($data_dir . $filename, "x");

      // Write the PID to the current condition index if successful;
      // otherwise, find another index.
      if (!$file) {
        continue;
      } else {
        // Sanitize our URL input, write it, and close the file.
        fwrite($file, htmlspecialchars($_GET["PROLIFIC_PID"]));
        fclose($file);

        // Find the condition that corresponds to the current condition index.
        $condition_assignment_file = fopen($experiment_dir . "condition_assignment.csv", "r");
        for ($j = 0; $j <= $i; $j++) {
          $condition_assignment = fgets($condition_assignment_file);
        }
        fclose($condition_assignment_file);
        break;
      }
    }
  }

  // Display an error message if no condition index was available.
  if ($i == $num_participants) {
    echo "ERROR: Please contact Michael Lopez-Brau at michael.lopez-brau@yale.edu.";
  } else {
    $_SESSION["condition_index"] = $i;
    $_SESSION["condition_assignment"] = $condition_assignment;
  }
}
?>

<html>
<script type="text/javascript">var quiz_attempts = <?php echo json_encode($quiz_attempts); ?>;</script>
<script type="text/javascript">var condition_assignment = <?php echo json_encode($condition_assignment); ?>;</script>
<head>
    <title>Psychology Study</title>

    <!-- External general utilities. -->
    <script src="shared/js/jquery-1.11.1.min.js "></script>
    <script src="shared/full-projects/jquery-ui/jquery-ui.min.js"></script>
    <script src="shared/js/underscore-min.js"></script>

    <!-- CoCoLab experiment logic. -->
    <script src="shared/js/exp-V2.js"></script>
    <script src="shared/js/stream-V2.js"></script>

    <!-- CoCoLab general utilities. -->
    <script src="shared/js/mmturkey.js "></script>
    <script src="shared/js/browserCheck.js"></script>
    <script src="shared/js/utils.js"></script>

    <!-- CSS files. -->
    <link href="shared/full-projects/jquery-ui/jquery-ui.min.css" rel="stylesheet" type="text/css"/>
    <link href="shared/css/cocolab-style.css" rel="stylesheet" type="text/css"/>
    <link href="css/local-style.css" rel="stylesheet" type="text/css"/>

    <!-- Experiment files. -->
    <script src="js/experiment_4.js"></script>

    <!-- Experiment specific helper functions. -->
    <script src="js/experiment_4_utils.js"></script>
</head>
<body onload="init();">
    <noscript>This task requires JavaScript.</noscript>

    <!-- Introduction slide. -->
    <div class="slide" id="i0">
        <div>
            <img id="logo" style="height:50px;width:50px;" src="shared/images/yale.jpg"></img>
            <span id="logo">Computation and Cognitive Development Lab</span>
        </div>
        <div id="instruct-text">
            <p>In this experiment, you will first read through the introduction and take a brief, 6-question quiz. Then, you will be shown a series of people in different rooms and asked to figure out where they were trying to go and where they came from.</p>
            <p>The experiment should take about <span class="time"></span> minutes. Press Start Experiment to begin.</p>
        </div>
        <div id="legal">
            <span style="text-align:center;font-weight:bold;">LEGAL INFORMATION</span>
            <br><br>
            <div style="height:30%;width:80%;margin:0px auto;border:1px solid #ccc;overflow:auto;">
                <p>Informed Consent Form</p>
                <p align="left">Purpose: We are conducting research on reasoning.</p>
                <p align="left">Procedures: This experiment takes around <span class="time"></span> minutes to complete. In each trial, you will view images and answer some range slider questions. You will receive <span class="payment"></span> upon completing the experiment.</p>
                <p align="left">Risks and Benefits: Completing this task poses no more risk of harm to you than do the experiences of everyday life (e.g., from working on a computer). Although this study will not benefit you personally, it will contribute to the advancement of our understanding of human reasoning.</p>
                <p align="left">Confidentiality: All of the responses you provide during this study will be anonymous. You will not be asked to provide any identifying information, such as your name, in any of the questionnaires. Typically, only the researchers involved in this study and those responsible for research oversight will have access to the information you provide. However, we may also share the data with other researchers so that they can check the accuracy of our conclusions; this will not impact you because the data are anonymous. The researcher will not know your name, and no identifying information will be connected to your survey answers in any way. The survey is therefore anonymous. However, your account is associated with an mTurk number that the researcher has to be able to see in order to pay you, and in some cases these numbers are associated with public profiles which could, in theory, be searched. For this reason, though the researcher will not be looking at anyone's public profiles, the fact of your participation in the research (as opposed to your actual survey responses) is technically considered "confidential" rather than truly anonymous.</p>
                <p align="left">Voluntary Participation: Your participation in this study is voluntary. You are free to decline to participate, to end your participation at any time for any reason, or to refuse to answer any individual question. Questions: If you have any questions about this study, you may contact Michael Lopez-Brau at <a style="text-decoration:none" href="mailto:michael.lopez-brau@yale.edu">michael.lopez-brau@yale.edu</a> or Julian Jara-Ettinger at julian.jara-ettinger@yale.edu. If you would like to talk with someone other than the researchers to discuss problems or concerns, to discuss situations in the event that a member of the research team is not available, or to discuss your rights as a research participant, you may contact, and mention HSC number 2000020357:</p>
                <p align="left" style="text-indent:180px;margin:0;">Yale University Human Subjects Committee</p>
                <p align="left" style="text-indent:180px;margin:0;">Box 208010, New Haven, CT 06520-8010</p>
                <p align="left" style="text-indent:180px;margin:0;">(203) 785-4688; human.subjects@yale.edu</p>
                <p align="left">Additional information is available <a style="text-decoration:none;" href="https://your.yale.edu/research-support/human-research/research-participants/rights-research-participant">here</a>.</p>
            </div>
            <p align="left">Agreement to participate: By clicking the button below, you acknowledge that you have read the above information, and agree to participate in the study. You must be at least 18 years of age to participate; agreeing to participate confirms you are 18 years of age or older.  Click the "Start Experiment" button to confirm your agreement and continue.</p>
        </div>
        <button id="start_button" type="button">Start Experiment</button>
    </div>

    <!-- Instruction slides. -->
    <div class="slide" id="introduction_0">
        <p>Please read carefully! You must pass the quiz to finish the experiment. If you fail the quiz <b>twice</b>, you will be ineligible for the experiment.</p>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_1">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;margin-bottom:0px;">You will be presented with some bird's-eye-view images of rooms with <b>3 labeled corners</b> and <b>up to 3 labeled doors</b>, like below:</p>
        <br><br><br>
        <div class="stimulus">
            <img style="height:250px;width:auto;" src="../stimuli/experiment_4/introduction_1.png"></img>
        </div>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_2">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;margin-bottom:0px;">The corners are labeled <span style="font-family:Lucida Console;">A</span>, <span style="font-family:Lucida Console;">B</span>, and <span style="font-family:Lucida Console;">C</span>. The corners always have the same label from one room to the next.</p>
        <br><br><br>
        <div class="stimulus">
            <img style="height:250px;width:auto;" src="../stimuli/experiment_4/introduction_2.png"></img>
        </div>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_3">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;margin-bottom:0px;">The doors are labeled <span style="font-family:Lucida Console";>1</span>, <span style="font-family:Lucida Console";>2</span>, and <span style="font-family:Lucida Console";>3</span>. Pay particular attention to the door numbers since Door <span style="font-family:Lucida Console";>1</span> in one room may not be Door <span style="font-family:Lucida Console";>1</span> in the next. Again, some rooms only have 2 doors.</p>
        <br><br><br>
        <div class="stimulus">
            <img style="height:250px;width:auto;" src="../stimuli/experiment_4/introduction_3.png"></img>
        </div>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_4">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;margin-bottom:0px;">In each room, a different person walks to one of the 3 corners. They always walk directly from the door to their desired corner and always take the same route to leave as they did to enter. People can walk horizontally and vertically, but they cannot walk diagonally anywhere in the room.</p>
        <br><br>
        <div class="stimulus">
            <img style="height:250px;width:auto;" src="../stimuli/experiment_4/introduction_4.png"></img>
        </div>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_5">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;margin-bottom:0px;">Some rooms will have gray walls that people (here, the black dot) cannot walk through and instead have to walk around. People are familiar with the rooms they are walking in, so they always know where all of the corners are, even if there are walls in the way.</p>
        <br><br>
        <div class="stimulus">
            <img style="height:250px;width:auto;" src="../stimuli/experiment_4/introduction_5.png"></img>
        </div>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_6">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;margin-bottom:0px;">People do <b>not</b> get to choose which door they enter. Someone else randomly chooses a door for them to walk through, regardless of which corner they want to walk to. People will still go for their preferred corner, even if it is farther away than other corners. Again, people always take the same route to leave as they did to enter.</p>
        <br>
        <div class="stimulus">
            <img style="height:273;width:auto;margin-left:23px;" src="../stimuli/experiment_4/introduction_6.png"></img>
        </div>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_7">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;">In each trial, you will be given some information about someone's <span class="num_visits"></span> previous visits into the room, and you will have to figure out which corner they were going for and which door they came from on their <span class="latest_visit"></span>th visit.</p>
        <p align="left" style="text-indent:40px;">This experiment will be split into two sections. <span class="prior_manipulation_order"></span></p>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_8">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;margin-bottom:0px;">Below is an example of what you will see after someone walked to <span style="font-family:Lucida Console;">A</span> 2 times, <span style="font-family:Lucida Console;">B</span> 6 times, and <span style="font-family:Lucida Console;">C</span> 1 time.</p>
        <br><br><br>
        <div class="stimulus" style="display:grid;grid-template-columns:1fr;position:relative;justify-items:center;">
            <img style="height:250;width:auto;grid-row:1;grid-column:1;z-index:0;" src="../stimuli/experiment_4/introduction_7a.png"></img>
            <img style="height:250;width:auto;grid-row:1;grid-column:1;z-index:1;" src="../stimuli/experiment_4/introduction_7b.png"></img>
        </div>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_9">
        <h3>Introduction</h3>
        <p align="left" style="text-indent:40px;margin-bottom:0px;">In each trial, you don't get to see them walking, so you do not know which door they came in through or which corner they wanted on their most recent visit. You only see which corners they walked to or which doors they walked through previously, and notice that they always leave some cookie crumbs along their path. You don't know how far along their path they were when they dropped these crumbs.</p>
        <div class="stimulus" style="display:grid;grid-template-columns:1fr;position:relative;justify-items:center;">
            <img style="height:250;width:auto;grid-row:1;grid-column:1;z-index:0;" src="../stimuli/experiment_4/introduction_8a.png"></img>
            <img style="height:250;width:auto;grid-row:1;grid-column:1;z-index:1;" src="../stimuli/experiment_4/introduction_8b.png"></img>
        </div>
        <button onclick="_s.button()">Continue</button>
    </div>
    <div class="slide" id="introduction_10">
        <h3>Introduction</h3>
        <p>Your task is to figure out:</p>
        <ul style="text-align:left;">
            <li>Which door that person walked through (using a scale from "definitely not" to "definitely" for each available door)</li>
            <li>Which corner that person was going for (using a scale from "definitely not" to "definitely" for each corner <span style="font-family:Lucida Console";>A</span>, <span style="font-family:Lucida Console";>B</span>, and <span style="font-family:Lucida Console";>C</span>)</li>
        </ul>
        <p>As a reminder, people cannot walk through the walls or walk diagonally anywhere in the room.</p>
        <p>There are <span class="num_trials"></span> trials in total. Press Continue to begin the quiz.</p>
        <button onclick="_s.button()">Continue</button>
    </div>

    <!-- Catch trial slide. -->
    <div class="slide" id="catch_trial">
        <p class="catch_slide"></p>
        <p class="catch_error">Please answer all of the questions before continuing.</p>
        <button onclick="_s.button()">Continue</button>
    </div>

    <!-- Trial slides. -->
    <div class="trial_slides"></div>

    <!-- Subject information slides. -->
    <div class="slide" id="subj_info">
        <div class="long_form">
            <div class="subj_info_title">Additional Information</div>
            <p class="info">Answering these questions is optional, but will help us understand your answers.</p>
            <p>Did you read the introduction and do you think you did the experiment correctly?</p>
            <label><input type="radio" name="assess" value="No"/>No</label>
            <label><input type="radio" name="assess" value="Yes"/>Yes</label>
            <label><input type="radio" name="assess" value="Confused"/>I was confused</label>
            <p>Were there any problems or bugs in the experiment?</p>
            <textarea id="problems" rows="2" cols="50"></textarea>
            <p>Gender:
                <select id="gender">
                    <label><option value=""/></label>
                    <label><option value="Male"/>Male</label>
                    <label><option value="Female"/>Female</label>
                    <label><option value="Other"/>Other</label>
                </select>
            </p>
            <p>Age: <input type="text" id="age"/></p>
            <p>Level of Education:
                <select id="education">
                    <label><option value="-1"/></label>
                    <label><option value="0"/>Some High School</label>
                    <label><option value="1"/>Graduated High School</label>
                    <label><option value="2"/>Some College</label>
                    <label><option value="3"/>Graduated College</label>
                    <label><option value="4"/>Hold a higher degree</label>
                </select>
            </p>
            <p>Native Language: <input type="text" id="language"/></p>
            <label>(the language(s) spoken at home when you were a child)</label>
            <p>Any additional comments about this experiment:</p>
            <textarea id="comments" rows="3" cols="50"></textarea>
            <br/>
            <button onclick="_s.submit()">Submit</button>
        </div>
    </div>

    <div id="thanks" class="slide js">
        <p class="big">Thank you for your participation! Press Finish Experiment to finish the experiment and receive your completion link.</p>
        <div class="end"></div>
    </div>

    <div class="progress">
        <span>Progress:</span>
        <div class="bar-wrapper">
            <div class="bar" width="0%"></div>
        </div>
    </div>
</body>
</html>
