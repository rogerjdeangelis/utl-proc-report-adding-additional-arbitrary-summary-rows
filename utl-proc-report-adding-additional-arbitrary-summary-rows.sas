Proc report adding additional arbitrary summary rows

Maybe I don not understand the problem?

Just use a muti-labelformat to add any special mean you want.

I think this is a important question?

github
https://tinyurl.com/sm6rnmm
https://github.com/rogerjdeangelis/utl-proc-report-adding-additional-arbitrary-summary-rows

SAS Forum
https://tinyurl.com/qpqzos3
https://communities.sas.com/t5/ODS-and-Base-Reporting/PROC-REPORT-Adding-Additional-Summarize-Row-Summing-Specific/m-p/612806

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

data have;
  set sashelp.classfit(keep=age height weight);
run;quit;

proc format;
  value agelfmt (multilabel notsorted)
     11='11'
     12='12'
     13='13'
     14='14'
     15='15'
     16='16'
     11-12='11 or 12'
     13-14='13 or 14'
     15-16='15 or 16'
     low-13='13 and below'
     14-high='14 and above'
     11,13,15-high="Special Sum";
run;quit;

 WORK.HAVE total obs=19

  AGE    HEIGHT    WEIGHT

   11     51.3       50.5
   12     56.3       77.0
   13     56.5       84.0
   12     57.3       83.0
   11     57.5       85.0
....

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;
                    Mean
               Height  Weight
 Age Group      (in.)  (lbs.)
 11             54.40   67.75
 12             59.44   94.40
 13             61.43   88.67
 14             64.90  101.88
 15             65.63  117.38
 16             72.00  150.00
 11 or 12       58.00   86.79
 13 or 14       63.41   96.21
 15 or 16       66.90  123.90
 13 and below   59.03   87.35
 14 and above   66.01  114.11

 Special Sum    62.76  102.10   Any combination of ages you want

                62.34  100.03   Overall Summary

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

proc report data=sashelp.classfit out=havPre;

   column age ('Mean' height weight);

   define age / group mlf format=agelfmt. 'Age Group' order=data preloadfmt;
   define height / mean format=6.2 'Height (in.)';
   define weight / mean format=6.2 'Weight (lbs.)';
   RBREAK AFTER / SUMMARIZE style=[font_style=italic font_weight=medium] ;

run;quit;


