/*
  wx_hbcompat.ch : To have Harbour compatibility
  Teo. Mexico 2008
*/

#ifdef __XHARBOUR__

#include "hbcompat.ch"

/* some missing translations */
#xtranslate hb_HASH([<x,...>])          => HASH(<x>)
#xtranslate hb_HHASKEY([<x,...>])       => HHASKEY(<x>)
#xtranslate hb_HPOS([<x,...>])          => HGETPOS(<x>)
#xtranslate hb_HGET([<x,...>])          => HGET(<x>)
#xtranslate hb_HSET([<x,...>])          => HSET(<x>)
#xtranslate hb_HDEL([<x,...>])          => HDEL(<x>)
#xtranslate hb_HKEYAT([<x,...>])        => HGETKEYAT(<x>)
#xtranslate hb_HVALUEAT([<x,...>])      => HGETVALUEAT(<x>)
#xtranslate hb_HVALUEAT([<x,...>])      => HSETVALUEAT(<x>)
#xtranslate hb_HPAIRAT([<x,...>])       => HGETPAIRAT(<x>)
#xtranslate hb_HDELAT([<x,...>])        => HDELAT(<x>)
#xtranslate hb_HKEYS([<x,...>])         => HGETKEYS(<x>)
#xtranslate hb_HVALUES([<x,...>])       => HGETVALUES(<x>)
#xtranslate hb_HFILL([<x,...>])         => HFILL(<x>)
#xtranslate hb_HCLONE([<x,...>])        => HCLONE(<x>)
#xtranslate hb_HCOPY([<x,...>])         => HCOPY(<x>)
#xtranslate hb_HMERGE([<x,...>])        => HMERGE(<x>)
#xtranslate hb_HEVAL([<x,...>])         => HEVAL(<x>)
#xtranslate hb_HSCAN([<x,...>])         => HSCAN(<x>)
#xtranslate hb_HSETCASEMATCH([<x,...>]) => HSETCASEMATCH(<x>)
#xtranslate hb_HCASEMATCH([<x,...>])    => HGETCASEMATCH(<x>)
#xtranslate hb_HSETAUTOADD([<x,...>])   => HSETAUTOADD(<x>)
#xtranslate hb_HAUTOADD([<x,...>])      => HGETAUTOADD(<x>)
#xtranslate hb_HALLOCATE([<x,...>])     => HALLOCATE(<x>)
#xtranslate hb_HDEFAULT([<x,...>])      => HDEFAULT(<x>)

#endif
