criterion="/data/criterion/P2/13620,/data/criterion/P2/13590,/data/criterion/P2/13650,5#/data/criterion/P1/23040,/data/criterion/P1/23010,/data/criterion/P1/23070,2#/data/criterion/P5/12330,/data/criterion/P5/12300,/data/criterion/P5/12360,2#/data/criterion/P7/16170,/data/criterion/P7/16140,/data/criterion/P7/16200,5#/data/criterion/P10/19410,/data/criterion/P10/19380,/data/criterion/P10/19440,5#/data/criterion/P8/10800,/data/criterion/P8/10770,/data/criterion/P8/10830,3#/data/criterion/P1/22140,/data/criterion/P1/22110,/data/criterion/P1/22170,2#/data/criterion/P3/6420,/data/criterion/P3/6390,/data/criterion/P3/6450,2#/data/criterion/P8/23430,/data/criterion/P8/23400,/data/criterion/P8/23460,2#/data/criterion/P10/6540,/data/criterion/P10/6510,/data/criterion/P10/6570,5#/data/criterion/P10/13170,/data/criterion/P10/13140,/data/criterion/P10/13200,5#/data/criterion/P5/13560,/data/criterion/P5/13530,/data/criterion/P5/13590,3#/data/criterion/P9/15870,/data/criterion/P9/15840,/data/criterion/P9/15900,0#/data/criterion/P5/19080,/data/criterion/P5/19050,/data/criterion/P5/19110,2#/data/criterion/P7/9060,/data/criterion/P7/9030,/data/criterion/P7/9090,3#/data/criterion/P9/17340,/data/criterion/P9/17310,/data/criterion/P9/17370,2#/data/criterion/P10/21270,/data/criterion/P10/21240,/data/criterion/P10/21300,5#/data/criterion/P1/4230,/data/criterion/P1/4200,/data/criterion/P1/4260,0#/data/criterion/P1/20580,/data/criterion/P1/20550,/data/criterion/P1/20610,5#/data/criterion/P8/12990,/data/criterion/P8/12960,/data/criterion/P8/13020,3#/data/criterion/P5/27090,/data/criterion/P5/27060,/data/criterion/P5/27120,1#/data/criterion/P7/660,/data/criterion/P7/630,/data/criterion/P7/690,0#/data/criterion/P8/18540,/data/criterion/P8/18510,/data/criterion/P8/18570,1#/data/criterion/P10/23640,/data/criterion/P10/23610,/data/criterion/P10/23670,0#/data/criterion/P2/2880,/data/criterion/P2/2850,/data/criterion/P2/2910,3#/data/criterion/P9/19650,/data/criterion/P9/19620,/data/criterion/P9/19680,3#/data/criterion/P3/13020,/data/criterion/P3/12990,/data/criterion/P3/13050,1#/data/criterion/P4/4230,/data/criterion/P4/4200,/data/criterion/P4/4260,3#/data/criterion/P2/10560,/data/criterion/P2/10530,/data/criterion/P2/10590,2#/data/criterion/P8/2280,/data/criterion/P8/2250,/data/criterion/P8/2310,0#/data/criterion/P4/5220,/data/criterion/P4/5190,/data/criterion/P4/5250,2#/data/criterion/P9/5880,/data/criterion/P9/5850,/data/criterion/P9/5910,3#/data/criterion/P5/6480,/data/criterion/P5/6450,/data/criterion/P5/6510,2#/data/criterion/P9/13740,/data/criterion/P9/13710,/data/criterion/P9/13770,3#/data/criterion/P6/4020,/data/criterion/P6/3990,/data/criterion/P6/4050,3#/data/criterion/P6/9150,/data/criterion/P6/9120,/data/criterion/P6/9180,2#/data/criterion/P5/6600,/data/criterion/P5/6570,/data/criterion/P5/6630,2#/data/criterion/P3/19980,/data/criterion/P3/19950,/data/criterion/P3/20010,5#/data/criterion/P4/3930,/data/criterion/P4/3900,/data/criterion/P4/3960,3#";

criterionSplit=[];

criterionSounds=[];
criterionSounds_pre=[];
criterionSounds_post=[];
criterionImages=[];
criterionImages_pre=[];
criterionImages_post=[];
currentImage=1;
epoch=1;
change=true;
font=null;
userStage="";

practiceStage=0;

totalClicks=0;
results="";


startTime=Date.now();

function preload() {
  //font=loadFont("/data/font.vlw");
  criterionSplit=criterion.split("#");

criterionSplit.forEach((val) => {
    if (val.length > 1) {
      try {
      console.log(val);
      splitup=val.split(",");
      try{
      img1=loadImage(splitup[0]+".png");
      sound = loadSound(splitup[0]+".wav");
      criterionSounds.push(sound);
      criterionImages.push(img1);
      } catch (exceptionVar) {
        console.log("Error on image: "+splitup[0]+exceptionVar);
    }
     try {
      img2=loadImage(splitup[1]+".png");
      sound = loadSound(splitup[1]+".wav");
      criterionSounds_pre.push(sound);
      criterionImages_pre.push(img2);
      }
      catch (exceptionVar) {
        console.log("Error on image: "+splitup[1]+exceptionVar);
      }
      try {
      img3=loadImage(splitup[2]+".png");
      sound = loadSound(splitup[2]+".wav");
      criterionSounds_post.push(sound);
      criterionImages_post.push(img3);
      }
      catch (exceptionVar) {
        console.log("Error on image: "+splitup[2]);
      }
      }
      catch (exceptionvar) {
        
      }
      
}


});
console.log("Size of pre images is "+criterionImages_pre.length);
console.log("Size of post images is "+criterionImages_post.length);
}

function setup() {
  createCanvas(1200, 600);
  textFont("Helvetica");
  textSize(20);
      /*
      img=loadImage((parseInt(splitup[0])-30)+".png");
      criterionImages_pre.push(img);
*/
      
      
    }
    
function dropoutCorrect(stage) {
  
  correct=criterionSplit[currentImage].split(",")[3];
  if (correct.indexOf(stage) > -1 || true) { //if it was correct, remove this item from all the arrays
    criterionSounds.splice(currentImage,1);
    criterionSounds_pre.splice(currentImage,1);
    criterionSounds_post.splice(currentImage,1);
    criterionImages.splice(currentImage,1);
    criterionImages_pre.splice(currentImage,1);
    criterionImages_post.splice(currentImage,1);
    criterionSplit.splice(currentImage,1);
  }
  
}
    
function keyPressed() {
  if (practiceStage == 1) {
  if (keyCode == RIGHT_ARROW) {
    epoch++;
    totalClicks++;
  }
  if (keyCode == LEFT_ARROW) {
    epoch--;
    totalClicks++;
  }
  if (epoch < 0) {
    epoch=0;
    totalClicks--;
  }
  if (epoch > 2) {
    epoch=2;
    totalClicks--;
  }
  change=true;
  if (epoch == 1) { //we are viewing the epoch
    if (key == '0' || key == '1' || key == '2' || key == '3' || key == 'r' || key == 'R' || key == 'w' || key == 'W') {
      if (key == 'r' || key == 'R') {
          userStage='5';
      }
      if (key == 'w' || key == 'W') {
          userStage='0';
      }
      else {
      userStage=key;
      }
      practiceStage=2;
      criterionSounds[currentImage].play();
      timeSpent=round((Date.now()-startTime)/1000,2);
      correct=criterionSplit[currentImage].split(",")[3];
	  //@sam this runs once per trial and updates the results for each trial. UserStage is the stage the person said, correct is the correct stange, timeSpent is the number of seconds spent on the trial and totalClicks is the number of backwards or forwards command shtye gave.
      results=results+","+userStage+":"+correct+":"+timeSpent+":"+totalClicks;
      totalClicks=0;
      
    }
    
    
  }
  }
  else if (practiceStage == 2) {
    dropoutCorrect(userStage);
    if (key == ' ') {
      if (criterionSounds.length > 0) {
        currentImage=Math.floor(Math.random() * criterionSounds.length);
        practiceStage = 1;
        epoch=1;
        startTime=Date.now();
      }
      else {
        practiceStage=3;
        console.log("No more items!");
      }
    
    }
  }
}

function mouseClicked() {
  if (practiceStage == 0) {
    practiceStage=1;
    startTIme=Date.now();
  }
  
}
function draw() {
  stroke(255);
  fill(255);
  
  if (practiceStage == 0) {
    background(0);
    text("Welcome to the sleep staging experiment!\nClicki anywhere to continue",0,50);
  }
  
  else if (practiceStage == 1) {

  imageMode(CENTER);
  if (epoch == 0) { ///showing the 30 seconds before the stage 
  background(0);
  if (criterionImages_pre[currentImage] != undefined && criterionSounds_pre[currentImage] != undefined) {

  image(criterionImages_pre[currentImage],600,240,1100,500,0,0,criterionImages_pre[currentImage].width,1420);
  if (change) {
    criterionSounds_pre[currentImage].play();
    change=false;
  }
  }
  text("This is one epoch before the epoch to stage. \nUse the right arrow to go forward in time.",0,520);
  }
  if (epoch == 1) { ///showing the stage 
  background(50);
  if (criterionImages[currentImage] != undefined && criterionSounds[currentImage] != undefined) {
  image(criterionImages[currentImage],600,240,1100,500,0,0,criterionImages[currentImage].width,1420);
  if (change) {
   criterionSounds[currentImage].play();
    change=false;
  }
  }
   text("This is the epoch to stage\n. Use arrow keys to move backwards or forwards in time. \nUse w, 1, 2, 3, and R keys to stage the epoch.",0,520);
  }
  if (epoch == 2) { ///showing the 30 seconds before the stage 
  background(0);
  if (criterionImages_post[currentImage] != undefined && criterionSounds_post[currentImage] != undefined) {
  image(criterionImages_post[currentImage],600,240,1100,500,0,0,criterionImages_post[currentImage].width,1420);
  if (change) {
    criterionSounds_post[currentImage].play();
    change=false;
  }
  }
   text("This is one epoch after the epoch to stage.\n Use the left arrow to go back in time.",0,520);
  }
  }
  else if (practiceStage == 2) { //getting feedback on stage
  background(0);
  image(criterionImages[currentImage],600,240,1100,500,0,0,criterionImages[currentImage].width,1420);
   
   correct=criterionSplit[currentImage].split(",")[3];
   text("This epoch is stage "+(correct+"").replace("5","REM").replace("0","wake")+".",0,520);
   if (correct.indexOf(userStage) > -1) {
     fill(0,200,0);
   }
   else {
     fill(200,0,0);
   }
   text("You said: Stage "+userStage.replace("5","REM").replace("0","wake")+"\nPress space to continue",0,550);
   
  }
  else if (practiceStage == 3) {
    alert(results);
    //practiceStage=4;
  }
    
  
  
}
