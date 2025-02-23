D'Occhio	Mario	900002

Il progetto si basa sull'aritmetica degli intervalli, un metodo per
eseguire calcoli numerici in modo che il risultato non sia un 
singolo valore, ma un intervallo che garantisce di contenere la
vera soluzione. Questa cosa è utile quando si tratta con errori di
arrotondamento che altrimenti potrebbero accumularsi e influenzare
in modo sensibile i risultati.

L'implementazione che ho fatto segue in maniera abbastanza precisa
le specifiche del progetto, non è particolarmente elegante
soprattutto nelle prime funzioni che ho scritto, ma comunque mi
sono applicato, spero sia abbastanza.

Anche in questa parte con Prolog ho inserito un pò di funzioni
di supporto, in particolare ho inserito un helper per la divisione
che contiene tutti i possibili casi di intervalli che si possono
presentare.

Non sono riuscito ad inserire (se non come risultato dei casi dove era
previsto per la divisione) gli intervalli disgiunti.
Nelle regole di consegna era segnato di mettere alle prime righe anche
dei file .lisp e .pl nome e matricola, l'ho fatto ma ho dovuto
commentarlo per evitare problemi con SWI-Prolog e Lispworks.