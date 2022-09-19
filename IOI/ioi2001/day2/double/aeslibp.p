unit AESlibp;
  { Copyright (c) 2001, IOI }
  { FreePascal library for task DOUBLE at IOI2001 Competition }

interface

const
  HexStrLen = 32;
  BlockLen  = 16;

type
  HexStr = String [ HexStrLen ]; { hex digits only: ['0'..'9', 'A'..'F'] }
  Block  = array [ 0 .. BlockLen-1 ] of Byte;

procedure HexStrToBlock ( const hs: HexStr; var b: Block );
procedure BlockToHexStr ( const b: Block; var hs: HexStr );

procedure Encrypt ( const p, k: Block; var c: Block );
  { c = E(p,k) }
procedure Decrypt ( const c, k: Block; var p: Block );
  { p = D(c,k) }

{ End of interface for unit AESlibp }
