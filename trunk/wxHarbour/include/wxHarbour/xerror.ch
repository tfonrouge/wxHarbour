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

#ifndef __XHARBOUR__
/* TRY / CATCH / FINALLY / END */
#xcommand TRY  => BEGIN SEQUENCE WITH {|oErr| Break( oErr )}
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS
#endif

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
#endif
