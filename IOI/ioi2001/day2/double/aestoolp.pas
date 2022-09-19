program AEStoolp;
  { Copyright (c) 2001, IOI }
  { Task DOUBLE at IOI2001 Competition }
  { Example program using FreePascal library aeslibp }

uses AESlibp;

procedure Pad0 ( var s: String );
  begin
    s := UpCase ( s )

  ; while Length ( s ) < HexStrLen do begin
      s := s + '0'
    end { while }

  end; { Pad0 }

procedure Interact;
  { interactively encrypt/decrypt messages }
  const
    Unmodified = '';             { to mark unmodified block }
    Modified   = ' <-- updated'; { to mark modified block }
  var
    command: Char; { input command }
    p, k, c, tmp: HexStr;
    pt, ck, ct: Block;
    pStatus, kStatus, cStatus: String;
  begin
    p := ''
  ; k := ''
  ; c := ''
  ; pStatus := Unmodified
  ; kStatus := Unmodified
  ; cStatus := Unmodified

  ; repeat
      writeln
    ; Pad0 ( p )
    ; Pad0 ( k )
    ; Pad0 ( c )
    ; writeln ( 'Plaintext  = ', p, pStatus )
    ; writeln ( 'Key        = ', k, kStatus )
    ; writeln ( 'Ciphertext = ', c, cStatus )
    ; writeln ( 'HexStr index 12345678901234567890123456789012 (mod 10)' )
    ; writeln ( 'Block index   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 (mod 10)' )
    ; pStatus := Unmodified
    ; kStatus := Unmodified
    ; cStatus := Unmodified
    ; write ( 'P(laintext, K(ey, C(iphertext, E(ncrypt, D(ecrypt, S(wap, Q(uit? ' )
    ; readln ( command )
    ; command := UpCase ( command )
    ; case command of
      'P': begin
          write ( 'Plaintext?   ' )
        ; readln ( p )
        ; pStatus := Modified
        end;
      'K': begin
          write ( 'Key?         ' )
        ; readln ( k )
        ; kStatus := Modified
        end;
      'C': begin
          write ( 'Ciphertext?  ' )
        ; readln ( c )
        ; cStatus := Modified
        end;
      'E': begin
          HexStrToBlock ( p, pt )
        ; HexStrToBlock ( k, ck )
        ; Encrypt ( pt, ck, ct )
        ; BlockToHexStr ( ct, c )
        ; writeln ( 'Encrypted plaintext with key to ciphertext' )
        ; cStatus := Modified
        end;
      'D': begin
          HexStrToBlock ( c, ct )
        ; HexStrToBlock ( k, ck )
        ; Decrypt ( ct, ck, pt )
        ; BlockToHexStr ( pt, p )
        ; writeln ( 'Decrypted ciphertext with key to plaintext' )
        ; pStatus := Modified
        end;
      'S': begin
          tmp := p
        ; p := c
        ; c := tmp
        ; writeln ( 'Swapped plaintext and ciphertext' )
        ; pStatus := Modified
        ; cStatus := Modified
        end;
      'Q': writeln ( 'End of Interaction with aeslibp' );
      else writeln ( 'Unknown command ''', command, '''' )
      end { case }
    until command = 'Q'

  end; { Interact }

begin
  writeln ( 'Interactive Tool for Using FreePascal Library aeslibp' )
; Interact
end.
