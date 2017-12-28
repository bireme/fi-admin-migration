  (
   if p(v12) then
     if p(v12^i) then
       '<912 0>',v12,'</912>'
     else
       /* espanhol */
       if v12:' el ' or 
          /* v12:' El ' or */
          v12:' del ' or 
          v12:' los ' or 
          v12:' y ' or 
          v12:' en ' or 
          v12:' con ' or 
          v12:' una ' or 
          v12:' salud ' or 
          v12:' Salud ' or 
          v12:' debe ' or 
          v12:' SALUD ' or 
          v12:' ciento' or 
          v12:'tiene' or
          v12:' sin ' 
          then
           '<912 0>',v12,'^ies</912>'
       else
         /* portugues */
         if v12:' um ' or 
            v12:' uns ' or 
            v12:' uma ' or 
            v12:' umas ' or 
            v12:' de ' or 
            v12:' e ' or 
            v12:' em ' or 
            v12:' num ' or 
            v12:' numa ' or 
            v12:' dois ' or 
            v12:' nove ' or 
            v12:' na ' or 
            v12:' bem ' or 
            v12:' com ' or 
            v12:' desde ' or 
            v12:' sem ' or 
            v12:' sobre ' or 
            v12:' SOBRE ' or 
            v12:' mais ' or 
            v12:' As ' or 
            v12:' as ' or 
            v12:' nas ' or 
            v12:' com ' or 
            v12:' ou ' or 
            v12:'Os ' or
            v12:' os ' or 
            v12:' da ' or
            v12:' do ' or
            v12:' DO ' or
            v12:' das ' or
            v12:' deste ' or 
            v12:' muito ' or 
            v12:' tem' or 
            v12:' corpo ' or 
            v12:' artigo ' or
            v12:' estudo ' or
            v12:' tratamento ' or
            v12:'Comenta-se a ' or
            v12:' seu ' or
            v12:' ocorre '
            then 
             '<912 0>',v12,'^ipt</912>'
         else 
           /* ingles */
           if v12:' has ' or 
              v12:' is ' or 
              v12:' of ' or 
              v12:' or ' or 
              v12:' and ' or 
              v12:' for ' or 
              v12:' the ' or 
              v12:' in ' or 
              v12:' have ' or 
              v12:' with ' or 
              v12:' by ' or 
              v12:' his ' or 
              v12:' her ' or 
              v12:' to ' or
              v12:' at ' then 
               '<912 0>',v12,'^ien</912>'
           else
             /*  italiano */
             if v12:' ricopre ' then
               '<912 0>',v12,'^iit</912>'
             else
               /* '<1200 0>MFN: ',mfn,' - v2: ',v2[1],' - v12: ',v12,'</1200>' */
               '<1200 0>',v12,'</1200>'
             fi
           fi
         fi 
       fi
     fi
   fi
   ),
 
