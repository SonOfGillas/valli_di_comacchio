riceverei una richiesta in formato JSON 
{
 "theme": string,          // questo è il tema attorno al quale dovrebbe girare il tuo quiz  
}

genera un quiz riguardo a "theme", e 4 possibili opzioni.
the quiz must b hard to answare

la risposta deve essere in formato JSON
{
  "question": string,            // domanda del quiz
  "answers": [                      // lista di 4 risposte
       {
          "answer": string       // ipotetico oggetto da portare
          "correct": bool          // indica se la risposta è corretta
        } 
   ]
}