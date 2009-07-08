/*
 * $Id$
 */

/*
  wx_hbcompat.ch : To have Harbour compatibility
  Teo. Mexico 2008
*/

#ifdef __XHARBOUR__

//#include "hbcompat.ch"

/* some missing translations */
#xtranslate HB_HASH(            => HASH(
#xtranslate HB_HHASKEY(         => HHASKEY(
#xtranslate HB_HPOS(            => HGETPOS(
#xtranslate HB_HGET(            => HGET(
#xtranslate HB_HSET(            => HSET(
#xtranslate HB_HDEL(            => HDEL(
#xtranslate HB_HKEYAT(          => HGETKEYAT(
#xtranslate HB_HVALUEAT(        => HGETVALUEAT(
#xtranslate HB_HVALUEAT(        => HSETVALUEAT(
#xtranslate HB_HPAIRAT(         => HGETPAIRAT(
#xtranslate HB_HDELAT(          => HDELAT(
#xtranslate HB_HKEYS(           => HGETKEYS(
#xtranslate HB_HVALUES(         => HGETVALUES(
#xtranslate HB_HFILL(           => HFILL(
#xtranslate HB_HCLONE(          => HCLONE(
#xtranslate HB_HCOPY(           => HCOPY(
#xtranslate HB_HMERGE(          => HMERGE(
#xtranslate HB_HEVAL(           => HEVAL(
#xtranslate HB_HSCAN(           => HSCAN(
#xtranslate HB_HSETCASEMATCH(   => HSETCASEMATCH(
#xtranslate HB_HCASEMATCH(      => HGETCASEMATCH(
#xtranslate HB_HSETAUTOADD(     => HSETAUTOADD(
#xtranslate HB_HAUTOADD(        => HGETAUTOADD(
#xtranslate HB_HALLOCATE(       => HALLOCATE(
#xtranslate HB_HDEFAULT(        => HDEFAULT(

#xtranslate <v>:__enumIndex()   => hb_enumIndex()

#xtranslate HB_ISCHAR(          => HB_ISSTRING(

/* ADel requieres xHarbour HB_C52_STRICT */
#xtranslate HB_ADel(            => ADel(

#endif
