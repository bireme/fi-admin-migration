  'd25', 
  (
   if p(v25) then
     if p(v25^i) then
       '<25 0>',v25,'</25>'
     else
       /* espanhol */
       if v25:' el ' or 
          /* v25:' El ' or */
          v25:' del ' or 
          v25:' los ' or 
          v25:' y ' or 
          v25:' en ' or 
          v25:' con ' or 
          v25:' una ' or 
          v25:' salud ' or 
          v25:' Salud ' or 
          v25:' debe ' or 
          v25:' SALUD ' or 
          v25:' ciento' or 
          v25:'tiene' or
          v25:' sin ' 
          then
           '<25 0>',v25,'^ies</25>'
       else
         /* portugues */
         if v25:' um ' or 
            v25:' uns ' or 
            v25:' uma ' or 
            v25:' umas ' or 
            v25:' de ' or 
            v25:' e ' or 
            v25:' em ' or 
            v25:' num ' or 
            v25:' numa ' or 
            v25:' dois ' or 
            v25:' nove ' or 
            v25:' na ' or 
            v25:' bem ' or 
            v25:' com ' or 
            v25:' desde ' or 
            v25:' sem ' or 
            v25:' sobre ' or 
            v25:' SOBRE ' or 
            v25:' mais ' or 
            v25:' As ' or 
            v25:' as ' or 
            v25:' nas ' or 
            v25:' com ' or 
            v25:' ou ' or 
            v25:'Os ' or
            v25:' os ' or 
            v25:' da ' or
            v25:' do ' or
            v25:' DO ' or
            v25:' das ' or
            v25:' deste ' or 
            v25:' muito ' or 
            v25:' tem' or 
            v25:' corpo ' or 
            v25:' artigo ' or
            v25:' estudo ' or
            v25:' tratamento ' or
            v25:'Comenta-se a ' or
            v25:' seu ' or
            v25:' ocorre '
            then 
             '<25 0>',v25,'^ipt</25>'
         else 
           /* ingles */
           if v25:' has ' or 
              v25:' is ' or 
              v25:' of ' or 
              v25:' or ' or 
              v25:' and ' or 
              v25:' for ' or 
              v25:' the ' or 
              v25:' in ' or 
              v25:' have ' or 
              v25:' with ' or 
              v25:' by ' or 
              v25:' his ' or 
              v25:' her ' or 
              v25:' at ' then 
               '<25 0>',v25,'^ien</25>'
           else
             /*  italiano */
             if v25:' ricopre ' then
               '<25 0>',v25,'^iit</25>'
             else
               /* '<2500 0>MFN: ',mfn,' - v2: ',v2[1],' - v25: ',v25,'</2500>' */
               '<2500 0>',v25,'</2500>'
             fi
           fi
         fi 
       fi
     fi
   fi
   ),
 
