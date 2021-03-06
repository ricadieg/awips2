C MEMBER SARP51
C
C DESC READ AND STORE PARAMETERS FOR SAR SECTION OF OPERATION 51
C
C--------------------------------------------------------------------
C
C@PROCESS LVL(77)
C
      SUBROUTINE SARP51(WK,IUSEW,LEFTW,NPSAR)
C
C----------------------------------------------------------------------
C  ARGS:
C     WK - ARRAY TO BE FILLED WITH THE PARAMETERS
C    IUSEW - NUMBER OF WORDS ALREADY USED IN WORK ARRAY
C    LEFTW - NUMBER OF WORDS LEFT IN WORK ARRAY
C    NPSAR - NUMBER OF WORDS NEEDED TO STORE SAR PARAMETERS
C---------------------------------------------------------------------
C
C  KUANG HSU - HRL - APRIL 1994
C----------------------------------------------------------------
      INCLUDE 'common/fld51'
      INCLUDE 'common/read51'
      INCLUDE 'common/comn51'
C
      DIMENSION KEYWDS(2,8),LKEYWD(8),VALUE(100),QSTOR(50),WK(*),
     .OK(5),IG(8)
      LOGICAL OK
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_ssarresv/RCS/sarp51.f,v $
     . $',                                                             '
     .$Id: sarp51.f,v 1.2 1996/12/10 14:41:24 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA KEYWDS/
     .            4HELVS,4HSTOR,4HQVSE,4HL   ,4HMAXE,4HL   ,
     .            4HMINE,4HL   ,4HMINQ,4HREL ,4HENDP,4H    ,
     .            4HENDP,4HARMS,4HENDS,4HAR  /
      DATA LKEYWD/2,2,2,2,2,1,2,2/
      DATA NKEYWD/8/
      DATA NDKEY/2/
C
C  INITIALIZE LOCAL VARIABLES AND COUNTERS
C
      QRELMN = 0.0
      NSE = 0
      NQE = 0
      NPSAR = 0
      LCARD = NCARD
      USEDUP = .FALSE.
C
C  4 KEYWORDS = ELVSTOR, QVSEL, MAXEL, MINEL,MINQREL
      DO 3 I = 1,5
 3    OK(I) = .TRUE.
C
      DO 5 I = 1,8
 5    IG(I) = 0
C-----------------------------------------------------------------
C  NOW LOOK FOR MATCHING KEYWORDS IN INPUT STREAM
C
   10 CONTINUE
      NUMFLD = 0
      CALL UFLD51(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
   20 CONTINUE
      NUMWD = (LEN-1)/4 + 1
      IDEST = IKEY26(CHAR,NUMWD,KEYWDS,LKEYWD,NKEYWD,NDKEY) + 1
C
      GO TO (100,300,400,500,600,700,1000,1000,1100) , IDEST
C
C---------------------------------------------------------------------
C  NO VALID KEYWORD FOUND
C
  100 CONTINUE
      CALL STER51(1,1)
      GO TO 10
C
C-----------------------------------------------------------------------
C   'ELVSSTOR' FOUND
C  SET INDICATOR THAT CURVE HAS BEEN FOUND, IF CURVE HAS ALREADY BEEN
C  FOUND, IT IS AN ERROR
C
  300 CONTINUE
      ID = IDEST - 1
      IG(ID) = IG(ID) + 1
      IF(IG(ID).LE.1) GO TO 310
      CALL STER51(39,1)
C
  305 CONTINUE
      NUMFLD = 0
      CALL UFLD51(NUMFLD,IERF)
      IF (IERF.EQ.3) GO TO 9000
      IF (ITYPE.LE.1) GO TO 305
      GO TO 20
C
C  START GETTING NUMBERS FOR CURVE DEFINITION. RULES FOR INPUT ARE
C  A CONTINUATION SYMBOL (&) MUST END THE LINE AS A STAND ALONE CHAR-
C  ACTER, AND SINCE THE CURVE IS A SET OF PAIRS THE TOTAL NUMBER
C  OF VALUES MUST BE EVEN.
C
  310 CONTINUE
C
      NVAL=100
      CALL GLST51(1,1,X,VALUE,X,NVAL,OK(ID))
      IF (.NOT.OK(ID)) GO TO 10
C
C  ALL VALUES ARE REAL AND WE'VE NO MORE INPUT ON A LINE(NO CONTINUATION
C  NOW WE HAVE TO CHECK THE VALUES FOR A CERTAIN AMOUNT OF VALIDITY
C  BEFORE WE CAN STORE THEM. ONE IS THAT THE NUMBER OF VALUES ARE EVEN
C  AS WE HAVE TO INPUT SETS OF PAIRS, THE OTHER IS THAT EACH HALF OF THE
C  VALUES ARE IN ASCENDING ORDER.
C
  350 CONTINUE
      IF (MOD(NVAL,2).EQ.0) GO TO 355
C
      CALL STER51(40,1)
      OK(ID) = .FALSE.
      GO TO 10
C
C  SEE IF EACH HALF ARE IN ASCENDING ORDER
C
  355 CONTINUE
      NHALF = NVAL/2
C
C  STORE THE ELEVATION VS STORAGE CURVE IN /COMN51/.
C
      NSE = NHALF
C
      DO 360 I=1,2
      J = (I-1)*NHALF
      DO 357 K = 2,NHALF
      IF (VALUE(J+K).GT.VALUE(J+K-1)) GO TO 357
      CALL STER51(41,1)
      OK(ID) = .FALSE.
      NUMFLD = 0
      GO TO 10
C
  357 CONTINUE
  360 CONTINUE
C
C  SEE IF FIRST STORAGE VALUE IS ZERO.
C
      NSTOR1=NVAL/2+1
      NSTOR2=NSTOR1+1
      IF (VALUE(NSTOR1).LE.0.10) GO TO 370
C
      CALL STER51(58,1)
      OK(ID) = .FALSE.
      GO TO 10
  370 CONTINUE
C
C  STORE ELEVATION/STORAGE CURVE
C
      DO 380 I=1,NSE
      ELSTOR(I) = VALUE(I)
      STORGE(I) = VALUE(NHALF+I)
  380 CONTINUE
      ELMIN = ELSTOR(1)
      ELMAX = ELSTOR(NSE)
C
C  INITIALIZE DISCHARGES TO 0.0 IF QVSEL HAS NOT BEEN FOUND
      IF(NQE.GT.0) GO TO 10
      NQE = NSE
      DO 390 I=1,NQE
 390  QSTOR(I) = 0.0
C
      GO TO 10
C
C-----------------------------------------------------------------------
C   'QVSEL' FOUND
C  SET INDICATOR THAT KEYWORD HAS BEEN FOUND, IF KEYWORD HAS ALREADY
C  BEEN FOUND, IT IS AN ERROR
C
  400 CONTINUE
      ID = IDEST - 1
      IG(ID) = IG(ID) + 1
      IF(IG(ID).LE.1) GO TO 410
      CALL STER51(39,1)
C
  405 CONTINUE
      NUMFLD = 0
      CALL UFLD51(NUMFLD,IERF)
      IF (IERF.EQ.3) GO TO 9000
      IF (ITYPE.LE.1) GO TO 405
      GO TO 20
C
C  START GETTING NUMBERS FOR CURVE DEFINITION. RULES FOR INPUT ARE
C  A CONTINUATION SYMBOL (&) MUST END THE LINE AS A STAND ALONE CHAR-
C  ACTER, NO OF DISCHARGES MUST BE EQUAL TO NO. OF ELEVATIONS
C
  410 CONTINUE
C
      NVAL=50
      CALL GLST51(1,1,X,VALUE,X,NVAL,OK(ID))
      IF (.NOT.OK(ID)) GO TO 10
C
C  ALL VALUES ARE REAL AND WE'VE NO MORE INPUT ON A LINE(NO CONTINUATION
C  NOW WE HAVE TO CHECK THE VALUES FOR A CERTAIN AMOUNT OF VALIDITY
C  BEFORE WE CAN STORE THEM. ONE IS THAT THE NUMBER OF VALUES OF
C  DISCHARGE AND ELEVATION MUST BE EQUAL, THE OTHER IS THAT
C  THE DISCHARGE VALUES ARE IN ASCENDING ORDER.
C
C
C  SEE IF VALUES ARE IN ASCENDING ORDER
C
      NQE = NVAL
      DO 457 K = 2,NQE
      IF (VALUE(K).GT.VALUE(K-1)) GO TO 457
      CALL STER51(41,1)
      OK(ID) = .FALSE.
      NUMFLD = 0
      GO TO 10
  457 CONTINUE
C
C  CHECK EQUAL NO. OF DISCHARGE AND ELEVATION/STORAGE VALUES
C  IN ELVSSTOR CURVE
C
      IF(NQE.EQ.NSE) GO TO 460
      CALL STER51(23,1)
      OK(ID) = .FALSE.
      GO TO 10
  460 CONTINUE
C
C  STORE DISCHARGE VALUES CORRESPONDING TO ELEVATION/STORAGE CURVE
C
      DO 480 I=1,NQE
      QSTOR(I) = VALUE(I)
  480 CONTINUE
C
      GO TO 10
C
C-------------------------------------------------------------------
C  'MAXEL' FOUND
C
 500  CONTINUE
      ID = IDEST - 1
      IG(ID) = IG(ID) + 1
      IF(IG(ID).GT.1) CALL STER51(39,1)
C
C  NEXT FIELD MUST BE REAL POSITIVE VALUE, ALSO WITHIN ELVSSTOR CURVE.
C
      NUMFLD= -2
      CALL UFLD51(NUMFLD,IERF)
      IF(IERF.GT.0)GO TO 9000
C
C  SEE IF VALUE IS REAL
      IF(ITYPE.EQ.1)GO TO 520
      CALL STER51(4,1)
      OK(ID) = .FALSE.
      GO TO 10
C
C  SEE IF VALUE IS POSITIVE
 520  IF(REAL.GT.0.0)GO TO 530
      CALL STER51(61,1)
      OK(ID) = .FALSE.
      GO TO 10
 530  ELMAX=REAL
C
C CHECK 'MAXEL' IS WITHIN BOUNDS OF THE ELVSSTOR CURVE
C
      IF(IG(1).LE.0) THEN
        CALL STER51(23,1)
        OK(ID) = .FALSE.
        GO TO 10
      END IF
      IF(IG(ID).GT.0 .AND. OK(ID)) THEN
        CALL ELST51(ELMAX,1,IERST)
        IF(IERST.GT.0) OK(ID) = .FALSE.
        GO TO 10
      END IF
      GO TO 10
C
C-----------------------------------------------------------------------
C  'MINEL' FOUND
C
 600  CONTINUE
      ID = IDEST - 1
      IG(ID) = IG(ID) + 1
      IF(IG(ID).GT.1) CALL STER51(39,1)
C
C  NEXT FIELD MUST BE REAL POSITIVE VALUE, ALSO WITHIN ELVSSTOR CURVE.
C
      NUMFLD = -2
      CALL UFLD51(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
C  SEE IF VALUE IS REAL
      IF(ITYPE.EQ.1)GO TO 620
      CALL STER51(4,1)
      OK(ID) = .FALSE.
      GO TO 10
C
C  SEE IF VALUE IS POSITIVE
 620  IF(REAL.GT.0.0)GO TO 630
      CALL STER51(61,1)
      OK(ID) = .FALSE.
      GO TO 10
 630  ELMIN=REAL
C
C CHECK MINEL IS WITHIN BOUNDS OF THE ELVSSTOR CURVE
C
      IF(IG(1).LE.0) THEN
        CALL STER51(23,1)
        OK(ID) = .FALSE.
        GO TO 10
      END IF
      IF(IG(ID).GT.0 .AND. OK(ID)) THEN
        CALL ELST51(ELMIN,1,IERST)
        IF(IERST.GT.0) OK(ID) = .FALSE.
        GO TO 10
      END IF
      GO TO 10
C
C-----------------------------------------------------------------------
C  'MINQREL' FOUND
C
 700  CONTINUE
      ID = IDEST - 1
      IG(ID) = IG(ID) + 1
      IF(IG(ID).GT.1) CALL STER51(39,1)
C
C  NEXT FIELD MUST BE REAL POSITIVE VALUE.
C
      NUMFLD = -2
      CALL UFLD51(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
C  SEE IF VALUE IS REAL
      IF(ITYPE.EQ.1)GO TO 720
      CALL STER51(4,1)
      OK(ID) = .FALSE.
      GO TO 10
C
C  SEE IF VALUE IS POSITIVE
 720  IF(REAL.GE.0.0)GO TO 730
      CALL STER51(61,1)
      OK(ID) = .FALSE.
      GO TO 10
 730  QRELMN=REAL
      GO TO 10
C
C------------------------------------------------------------------
C  'ENDP' FOUND. 
C   STORE THE CURVE AND OTHER PARMS IN WORK ARRAY IF EVERYTHIG OK.
C
 1000 CONTINUE
C
C 'ELVSSTOR' KEYWORD IS REQUIRED. IT IS AN ERROR IF NOT FOUND
C
      IF(IG(1).LE.0) CALL STRN51(59,1,KEYWDS(1,1),LKEYWD(1))
C
C CHECK NO. DISCHARGES EQUALS TO NO. OF ELEVATIONS OF THE ELVSSTOR CURVE
C
      IF(IG(2).GT.0) THEN
        IF(NQE.NE.NSE) THEN
          CALL STER51(42,1)
          OK(2) = .FALSE.
        END IF
      END IF
C
      DO 1103 I=1,4
 1103 IF(.NOT.OK(I)) GO TO 9999   
C
      NPSAR = 0
C
C  STORE RESERVOIR TYPE: =0, NON-BACKWATER RESERVOIR
C  =1, UPSTREAM RESERVOIR AFFECTED BY DOWNSTREAM RESERVOIR
C  =2, DOWNSTREAM RESERVOIR AFFECTED BY TRIBUTARY FLOW
C  =3, THREE VARIABLE RELATION WITHOUT BACKWATER ROUTING
C
      RESTYP=0.0
      CALL FLWK51(WK,IUSEW,LEFTW,RESTYP,501)
      NPSAR = NPSAR+1
C
C  STORE THE NO. OF DATA POINTS IN THE ELEVATION/STORAGE/DISCHARGE CURVE
C  FOLLOWED BY THE CURVE VALUES: ELEVATIONS, THEN STORAGES,
C  THEN DISCHARGE.
C
      COUNT = NSE
C
      CALL FLWK51(WK,IUSEW,LEFTW,COUNT,501)
      NPSAR = NPSAR+1
C
C  STORE ELEVATION VALUES
C
      DO 1620 I=1,NSE
      CALL FLWK51(WK,IUSEW,LEFTW,ELSTOR(I),501)
 1620 CONTINUE
      NPSAR = NPSAR+NSE
C
C  STORE STORAGE VALUES
C
      DO 1625 I=1,NSE
      CALL FLWK51(WK,IUSEW,LEFTW,STORGE(I),501)
 1625 CONTINUE
      NPSAR = NPSAR+NSE
C
C  STORE DISCHARGE VALUES
C
      DO 1630 I=1,NSE
      CALL FLWK51(WK,IUSEW,LEFTW,QSTOR(I),501)
 1630 CONTINUE
      NPSAR = NPSAR+NSE
C
C  STORE MAXIMUM ELEVATION
C
      CALL FLWK51(WK,IUSEW,LEFTW,ELMAX,501)
      NPSAR = NPSAR+1
C
C  STORE MINIMUM ELEVATION
C
      CALL FLWK51(WK,IUSEW,LEFTW,ELMIN,501)
      NPSAR = NPSAR+1
C
C  STORE MINIMUM RESERVOIR RELEASE
C
      CALL FLWK51(WK,IUSEW,LEFTW,QRELMN,501)
      NPSAR = NPSAR+1
C
C  ALL FINISHED WITH THE SAR PARMS. EXIT NOW.
C
      GO TO 9999
C
C---------------------------------------------------------------------
C  ERROR IN UFLD51
C
 9000 CONTINUE
      IF (IERF.EQ.1) CALL STER51(19,1)
      IF (IERF.EQ.2) CALL STER51(20,1)
      IF (IERF.EQ.3) CALL STER51(21,1)
      IF (IERF.EQ.4) CALL STER51(1,1)
C
      IF (IERF.NE.3) GO TO 10
C
C-----------------------------------------------------------------------
C  ENDSAR FOUND WHERE IT SHOULDN'T BE. SIGNAL ERROR AND RETURN
C
 1100 CONTINUE
      USEDUP =.TRUE.
      CALL STER51(43,1)
      GO TO 9999
C
C--------------------------------------------------------------------
C
 9999 CONTINUE
      OKELST = OK(1) .AND. OK(2)
      RETURN
      END
