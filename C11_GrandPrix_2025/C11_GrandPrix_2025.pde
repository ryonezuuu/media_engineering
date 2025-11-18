import java.io.*;
int CompariMode = 1;// [0]: Solo, [1]: Multiple
int StimNum = 0;
int curY = 0;
int NumOfItems;
int NumOfCombi;
int NumOfSub = 1;
int NumOfMulNum = 1;
int MagVal = 0;

int[] PairMat = new int[1000];// Matrix for pair
int[][] DataMat = new int[1000][1000];// Matrix for data
int tCount = 0;

int imgN1, imgN2;
int tPhase = 1;
String imgFolder = "";
String StimName = "";
String[] fileNames;
PImage[] myImgs;
PImage oriImg;
String[] words = new String[1000];
String fName = "";
void setup() {
  size(1200, 800);

  String myYear = "" + year();
  String myMonth = "" + nf(month(), 2, 0);
  String myDay = "" + nf(day(), 2, 0);
  String myHour = "" + nf(hour(), 2, 0);
  String myMinute = "" + nf(minute(), 2, 0);
  words[0] = myYear+ "/" + myMonth + "/"  + myDay + "/"  + myHour + ":"  + myMinute;
  fName = "" + myYear + "_" + myMonth + myDay + "_" + myHour + myMinute;
}
void draw() {
  background( 0 );
  if (tPhase == 1) {
    showMenu1();
  } else if (tPhase == 2) {
    showStim();
  }
}
void showStim() {
  float imgW = myImgs[0].width;
  float imgH = myImgs[0].height;
  float imgRatio = imgH / imgW;
  float imgX1, imgY1;
  float imgX2, imgY2;
  float imgX3, imgY3;

  imgW = width/3;
  imgH = imgW * imgRatio;

  imgX1 = width/3 - imgW/2 - imgW/3;
  imgX2 = 2*width/3 - imgW/2 + imgW/3;
  imgY1 = height/2 - imgH/2 + imgH/1.5;
  imgY2 = height/2 - imgH/2 + imgH/1.5;

  imgX3 = width/2 - imgW/2;
  imgY3 = height/2 - imgH/2 - imgH/1.5;

  noStroke();
  image(oriImg, imgX3, imgY3, imgW, imgH);
  image(myImgs[imgN1], imgX1, imgY1, imgW, imgH);
  image(myImgs[imgN2], imgX2, imgY2, imgW, imgH);

  fill(255);
  text(tCount+1 + "/" + NumOfCombi, width/8, height/8);
  noFill();
}
void showMenu1() {
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(20);

  text("Odd", width/8, height/5);
  text("Even", 2*width/8, height/5);

  noFill();
  strokeWeight(4);
  stroke(255, 255, 0);
  ellipse( (1 + StimNum)*width/8, height/5, width/8, height/10);
}
void setCompariItems() {
  for (int i=0; i<1000; i++) {
    for (int j = 0; j<1000; j++) {
      DataMat[i][j] = 0;
    }
  }

  NumOfCombi = ( NumOfItems  * (NumOfItems-1)) / (2*1);
  int[] checkMat = new int[NumOfCombi];
  for ( int i=0; i<NumOfCombi; i++) {
    checkMat[i] = 0;
  }
  for (int i=0; i<NumOfCombi; i++) {
    int k = 1;
    while (k>0) {
      int tmp = int(random(0, NumOfCombi));
      if (checkMat[tmp] == 0) {
        PairMat[i] = tmp;
        checkMat[tmp] = 1;
        k=0;
      }
    }
    //print(" " + PairMat[i]+";");
  }
  //println();
  //println("------------------");
}
void keyPressed() {
}
void keyReleased() {
  if (key==CODED) {
    if (keyCode==DOWN) {
      if (tPhase == 0) {
        if ( CompariMode == 1) {
          if ( NumOfMulNum >2 ) {
            NumOfMulNum = NumOfMulNum - 1;
            NumOfSub = NumOfMulNum;
          }
        }
      }
    }
    if (keyCode==UP) {
      if (tPhase == 0) {
        if ( CompariMode == 1) {
          NumOfMulNum = NumOfMulNum + 1;
          NumOfSub = NumOfMulNum;
        }
      }
    }
    if (keyCode==LEFT) {
      if (tPhase == 0) {
        if (curY == 0) {
          CompariMode = 0;
          NumOfSub = 100;
        }
      } else if (tPhase ==1) {
        if (StimNum > 0) {
          StimNum = StimNum - 1;
        }
      } else if (tPhase ==2) {
        MagVal = 0;
        // -----
        DataMat[imgN1][imgN2] = NumOfSub - MagVal;
        DataMat[imgN2][imgN1] = MagVal;

        if ( tCount < (NumOfCombi-1)) {
          tCount = tCount + 1;
          setNextTrial();
        } else if (tCount == (NumOfCombi-1) ) {
          Result();
          exit();
        }
      }
    }
    if (keyCode==RIGHT) {
      if (tPhase == 0) {
        if (curY == 0) {
          CompariMode = 1;
          NumOfSub = NumOfMulNum;
        }
      } else if (tPhase ==1) {
        if (StimNum < 1) {
          StimNum = StimNum + 1;
        }
      } else if (tPhase ==2) {

        MagVal = 1;
        // -----
        DataMat[imgN1][imgN2] = NumOfSub - MagVal;
        DataMat[imgN2][imgN1] = MagVal;

        if ( tCount < (NumOfCombi-1)) {
          tCount = tCount + 1;
          setNextTrial();
        } else if (tCount == (NumOfCombi-1) ) {
          Result();
          exit();
        }
      }
    }
  }
  if ( key == ENTER) {
    if ( tPhase == 0) {
      tPhase = 1;
    } else if ( tPhase == 1) {
      if (StimNum==0) {
        NumOfItems = 14;
        imgFolder = "imgs/C11_Odd/C11_Odd_";
        StimName = "Odd";
      } else if (StimNum==1) {
        NumOfItems = 10;
        imgFolder = "imgs/C11_Even/C11_Even_";
        StimName = "Even";
      }
      loadMyImages(imgFolder, NumOfItems);

      setCompariItems();
      setNextTrial();

      tPhase = 2;
    } else if ( tPhase == 2) {
    }
  }
}
void setNextTrial() {
  MagVal = NumOfSub / 2;

  int[] hMat = new int[NumOfItems-1];
  // println();
  for ( int i=0; i<NumOfItems-1; i++) {
    hMat[i] = NumOfItems - i - 1;
    // print(hMat[i] + ", ");
  }

  int k = 1;
  int jibun = 0;
  int hNum = hMat[jibun];
  int aite = 0;
  while (k>0) {
    if ( PairMat[tCount] < hNum) {
      //wNum = hIdx + hMat[hIdx] - (hNum - PairMat[tCount]) + 1;
      aite = NumOfItems - (hNum - PairMat[tCount]);
      k = 0;
    } else {
      jibun = jibun + 1;
      hNum = hNum + hMat[jibun];
    }
  }
  println(jibun + " - " + aite);
  imgN1 = jibun;
  imgN2 = aite;
}
void loadMyImages(String folderName, int Num) {
  myImgs = new PImage[Num];
  for (int i=0; i<Num; i++) {
    myImgs[i] = loadImage(folderName + "Img" + nf(i, 2, 0) + ".bmp");
    println(folderName + "Img" + nf(i, 2, 0) + ".bmp");
  }
  oriImg = loadImage(folderName + "ImgOrig.bmp");
}

void Result() {
  String[] newWords = new String[NumOfItems+4];
  newWords[0] = words[0];
  if (CompariMode == 0) {
    newWords[1] = "Solo";
  } else if (CompariMode == 1) {
    newWords[1] = "Multiple";
  }
  newWords[2] = "" + NumOfSub;

  String str = "";
  for (int i=0; i<NumOfItems; i++) {
    str = str + ",Stim_"+nf(i, 2, 0);
  }
  newWords[3] = str;

  for (int i=0; i<NumOfItems; i++) {
    str = "Stim_"+nf(i, 2, 0);
    for (int j=0; j<NumOfItems; j++) {
      str = str + "," + DataMat[i][j];
    }
    newWords[i+4] = str;
  }
  saveStrings(fName+"_"+StimName+".csv", newWords);
}
