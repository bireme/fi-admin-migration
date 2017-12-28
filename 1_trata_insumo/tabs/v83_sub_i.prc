  'd83', 
  (
   if p(v83) then
     if p(v83^i) then
       '<83 0>',v83,'</83>'
     else
       /* espanhol */
       if v83:' el ' or 
          /* v83:' El ' or */
          v83:' del ' or 
          v83:' los ' or 
          v83:' y ' or 
          v83:' en ' or 
          v83:' con ' or 
          v83:' una ' or 
          v83:' salud ' or 
          v83:' Salud ' or 
          v83:' debe ' or 
          v83:' SALUD ' or 
          v83:' ciento' or 
          v83:'tiene' or
          v83:' sin ' 
          then
           '<83 0>',v83,'^ies</83>'
       else
         /* portugues */
         if v83:' um ' or 
            v83:' uns ' or 
            v83:' uma ' or 
            v83:' umas ' or 
            v83:' de ' or 
            v83:' e ' or 
            v83:' em ' or 
            v83:' num ' or 
            v83:' numa ' or 
            v83:' dois ' or 
            v83:' nove ' or 
            v83:' na ' or 
            v83:' bem ' or 
            v83:' com ' or 
            v83:' desde ' or 
            v83:' sem ' or 
            v83:' sobre ' or 
            v83:' SOBRE ' or 
            v83:' mais ' or 
            v83:' As ' or 
            v83:' nas ' or 
            v83:' com ' or 
            v83:' ou ' or 
            v83:'Os ' or
            v83:' os ' or 
            v83:' da ' or
            v83:' do ' or
            v83:' DO ' or
            v83:' das ' or
            v83:' deste ' or 
            v83:' muito ' or 
            v83:' tem ' or 
            v83:' corpo ' or 
            v83:' artigo ' or
            v83:' estudo ' or
            v83:' tratamento ' or
            v83:' para ' or
            v83:' ocorre '
            then 
             '<83 0>',v83,'^ipt</83>'
         else 
           /* ingles */
           if v83:' has ' or 
              v83:' is ' or 
              v83:' of ' or 
              v83:' or ' or 
              v83:' and ' or 
              v83:' for ' or 
              v83:' the ' or 
              v83:' in ' or 
              v83:' have ' or 
              v83:' with ' or 
              v83:' by ' or 
              v83:' to ' or 
              v83:' at ' then 
               '<83 0>',v83,'^ien</83>'
           else
             /*  italiano */
             if v83:' ricopre ' then
               '<83 0>',v83,'^iit</83>'
             else
               '<8300 0>MFN: ',mfn,' - v2: ',v2[1],' - v83: ',v83,'</8300>'
             fi
           fi
         fi 
       fi
     fi
   fi
   ),
 
