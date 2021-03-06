C MEMBER SPGBOX
C-----------------------------------------------------------------------
C
C DESC PRINT GRID BOX PARAMETERS
C
      SUBROUTINE SPGBOX (IVGBOX,GBOXID,NUGBOX,BOXLOC,IBXADJ,IBXMDR,
     *   UNUSED,ISTAT)
C
      REAL MDR/4HMDR /,MDRT/4HMDRT/
C
      DIMENSION UNUSED(1)
      INCLUDE 'scommon/dimgbox'
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_print/RCS/spgbox.f,v $
     . $',                                                             '
     .$Id: spgbox.f,v 1.1 1995/09/17 19:14:06 dws Exp $
     . $' /
C    ===================================================================
C
C
C
      IF (ISTRCE.GT.0) WRITE (IOSDBG,60)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG(4HGBOX)
C
      ISTAT=0
      NUMERR=0
      NUMWRN=0
C
C  CHECK NUMBER OF LINES LEFT ON PAGE
      IF (ISLEFT(10).GT.0) CALL SUPAGE
C
C  PRINT HEADING
      WRITE (LP,80) GBOXID
      CALL SULINE (LP,2)
      WRITE (LP,100)
      CALL SULINE (LP,2)
C
C  PRINT PARAMETER ARRAY VERSION NUMBER
      IF (LDEBUG.EQ.0) GO TO 10
         WRITE (LP,110) IVGBOX
         CALL SULINE (LP,2)
C
C  PRINT GRID BOX IDENTIFIER AND NUMBER
10    WRITE (LP,120) GBOXID,NUGBOX
      CALL SULINE (LP,2)
C
C  PRINT BASE LATITUDE AND LONGITUDE
      WRITE (LP,140) BOXLOC
      CALL SULINE (LP,2)
C
C  PRINT NUMBER OF UNUSED POSITIONS
      NUNUSD=2
      IF (LDEBUG.EQ.0) GO TO 20
         WRITE (LP,150) NUNUSD
         CALL SULINE (LP,2)
C
C  PRINT ADJACENT GRID BOX NUMBERS
20    WRITE (LP,160) IBXADJ
      CALL SULINE (LP,2)
C
C  PRINT MDR USAGE OPTION
      XMDR=MDR
      IF (IBXMDR.EQ.0) XMDR=MDRT
      WRITE (LP,170) XMDR
      CALL SULINE (LP,2)
C
30    WRITE (LP,70)
      CALL SULINE (LP,1)
      WRITE (LP,90)
      CALL SULINE (LP,1)
C
40    IF (LDEBUG.GT.0.AND.ISTAT.EQ.0) WRITE (IOSDBG,180)
      IF (LDEBUG.GT.0.AND.ISTAT.EQ.0) CALL SULINE (IOSDBG,2)
C
50    IF (ISTRCE.GT.0) WRITE (IOSDBG,190) ISTAT
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
60    FORMAT (' *** ENTER SPGBOX')
70    FORMAT (1H )
80    FORMAT (1H0,60(1H-),' ID=',2A4,1X,59(1H-))
90    FORMAT (1H ,132(1H-))
100   FORMAT (1H )
110   FORMAT ('0PARAMETER ARRAY VERSION NUMBER = ',I2)
120   FORMAT ('0*--> GBOX PARAMETERS :   IDENTIFIER = ',2A4,5X,
     *   'NUMBER = ',I2)
130   FORMAT ('0NWSRFS/HRAP COORDINATES =  (',F6.1,',',F6.1,')')
140   FORMAT ('0BASE LATITUDE =  ',F6.2,5X,'BASE LONGITUDE = ',F7.2)
150   FORMAT ('0NUMBER OF UNUSED POSITIONS = ',I2)
160   FORMAT ('0ADJACENT GRID BOX NUMBERS = ',8(I2,1X))
170   FORMAT ('0MDR USAGE OPTION = ',A4)
180   FORMAT ('0*** NOTE - GBOX PARAMETERS SUCCESSFULLY PRINTED.')
190   FORMAT (' *** EXIT SPGBOX - STATUS CODE=',I2)
C
      END
