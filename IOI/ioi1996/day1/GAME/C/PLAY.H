
/*
 *    header file for the library Play
 */

#ifdef __BCPLUSPLUS__

extern "C" void  StartGame (void) ;
extern "C" void  MyMove    (char) ;
extern "C" void  YourMove  (char *) ;


#else

extern  void  StartGame (void) ;
extern  void  MyMove    (char) ;
extern  void  YourMove  (char *) ;

#endif
