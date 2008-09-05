/*
  xerror.ch - eXtended error manager
  Teo. Mexico 2007
*/

/* THROW => generate error */
#xtranslate THROW(<oErr>) => (Eval(ErrorBlock(), <oErr>), Break(<oErr>))

/* TRY / CATCH / FINALLY / END */
#xcommand TRY  => BEGIN SEQUENCE WITH {|oErr| Break( oErr )}
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS

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
