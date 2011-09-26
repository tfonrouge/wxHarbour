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
            wxhShowError( "", { wxhLABEL_ACCEPT }, <errObj> )

#define OODB_ERR__FIELD_METHOD_TYPE_NOT_SUPPORTED       1000
#define OODB_ERR__CALCULATED_FIELD_CANNOT_BE_SOLVED     1001
#define OODB_ERR__NO_BASEKEYFIELD                       1002

#xcommand THROW ERROR <errId> [ ON <obj> ] [ ARGS <args,...> ] ;
          => ;
          __objSendMsg( iif( <.obj.>, <obj>, Self ), "__Err_"[ , <args> ], <errId> )
#endif
