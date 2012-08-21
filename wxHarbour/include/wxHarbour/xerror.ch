/*
 * $Id$
 */

/*
    xerror.ch - eXtended error manager
    Teo. Mexico 2007
*/

#ifndef __XERROR_CH__
#define __XERROR_CH__
/* THROW => generate error */
#xtranslate THROW(<oErr>) => (Eval(ErrorBlock(), <oErr>), Break(<oErr>))

#xcommand RAISE ERROR <cDescription> ;
                                        [ SUBSYSTEM <cSubsystem> ] ;
                                        [ OPERATION <cOperation> ] ;
                                        [ ARGS <aArgs> ] ;
                    => ;
                    Throw( MyErrorNew( [<cSubsystem>], ;
                                                         [<cOperation>], ;
                                                            <cDescription>, ;
                                                         [<aArgs>], ;
                                                            ProcFile(), ;
                                                            ProcName(), ;
                                                            ProcLine() ;
                                                        ) ;
                                )

#xcommand SHOW ERROR <errObj> ;
                    => ;
            wxhShowError( NIL, { wxhLABEL_ACCEPT }, <errObj> )

#endif
