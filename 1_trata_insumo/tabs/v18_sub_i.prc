  'd18', 
  (
   if p(v18) then
     if p(v18^i) then
       '<18 0>',v18,'</18>'
     else
       /* espanhol */
       if v18:' el ' or 
          /* v18:' El ' or */
          v18:' del ' or 
          v18:' los ' or 
          v18:' y ' or 
          v18:' en ' or 
          v18:' con ' or 
          v18:' una ' or 
          v18:' salud ' or 
          v18:' Salud ' or 
          v18:' debe ' or 
          v18:' SALUD ' or 
          v18:' ciento' or 
          v18:'tiene' or
          v18:' sin ' 
          then
           '<18 0>',v18,'^ies</18>'
       else
         /* portugues */
         if v18:' um ' or 
            v18:' uns ' or 
            v18:' uma ' or 
            v18:' umas ' or 
            v18:' de ' or 
            v18:' e ' or 
            v18:' em ' or 
            v18:' num ' or 
            v18:' numa ' or 
            v18:' dois ' or 
            v18:' nove ' or 
            v18:' na ' or 
            v18:' bem ' or 
            v18:' com ' or 
            v18:' desde ' or 
            v18:' sem ' or 
            v18:' sobre ' or 
            v18:' SOBRE ' or 
            v18:' mais ' or 
            v18:' As ' or 
            v18:' as ' or 
            v18:' nas ' or 
            v18:' com ' or 
            v18:' ou ' or 
            v18:'Os ' or
            v18:' os ' or 
            v18:' da ' or
            v18:' do ' or
            v18:' DO ' or
            v18:' das ' or
            v18:' deste ' or 
            v18:' muito ' or 
            v18:' tem' or 
            v18:' corpo ' or 
            v18:' artigo ' or
            v18:' estudo ' or
            v18:' tratamento ' or
            v18:'Comenta-se a ' or
            v18:' seu ' or
            v18:' ocorre '
            then 
             '<18 0>',v18,'^ipt</18>'
         else 
           /* ingles */
           if v18:' has ' or 
              v18:' is ' or 
              v18:' of ' or 
              v18:' or ' or 
              v18:' and ' or 
              v18:' for ' or 
              v18:' the ' or 
              v18:' in ' or 
              v18:' have ' or 
              v18:' with ' or 
              v18:' by ' or 
              v18:' his ' or 
              v18:' her ' or 
              v18:' at ' then 
               '<18 0>',v18,'^ien</18>'
           else
             /*  italiano */
             if v18:' ricopre ' then
               '<18 0>',v18,'^iit</18>'
             else
               /* '<1800 0>MFN: ',mfn,' - v2: ',v2[1],' - v18: ',v18,'</1800>' */
               '<1800 0>',v18,'</1800>'
             fi
           fi
         fi 
       fi
     fi
   fi
   ),
 
