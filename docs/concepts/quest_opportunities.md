# Oppdragsidéer og miljøgåter

## Formål

Foreslå oppdragsidéer basert på dokumenterbare historiske forbindelser, miljøgåter som bruker begge tidsperiodene, NPC-forslag i begge tidslag, og metoder for at spilleren oppdager kunnskap uten lange forelesninger.

## Sammendrag

Oppdragene under er bygget direkte på stedparene i `location_pairs.md` og aha-øyeblikkene i `aha_moments.md`. Alle NPC-er er **eksplisitt fiktive** (kreativ frihet) — ingen er ment å representere navngitte, reelle historiske personer. Der en NPC-rolle er inspirert av dokumentert sosial rolle (f.eks. "gårdskone", "seidkone", "domstolsarkivar"), er dette markert. Den gjennomgående designlærdommen fra `research/game_design_references.md` er fulgt konsekvent: spillerens verktøy er observasjon og sammenligning, ikke kamp; miljøet — ikke dialogtekst — bærer mesteparten av informasjonen; og spillet skiller tydelig, i UI/dialog, mellom dokumentert fakta, sannsynlig rekonstruksjon og fri tolkning.

## Sist oppdatert

2026-07-23

## Status

foreløpig (kreativ syntese basert på fullført førstepass-research)

---

## Del 1: Prinsipper for kunnskapsoppdagelse uten forelesning

Hentet fra `research/game_design_references.md`s tverrgående designlærdommer, konkretisert for dette prosjektet:

1. **Miljøet snakker først, NPC-en snakker sist.** En fysisk detalj (en forsenkning i terrenget, en gjenstand halvveis nedgravd, en bygning bygget oppå en annen grunnmur) skal alltid være synlig og undersøkbar *før* noen NPC forklarer den. NPC-dialog bekrefter/utdyper, den introduserer sjelden.
2. **Spilleren gjør koblingen, ikke spillet.** Når spilleren bytter tidslag på et sted, skal ikke spillet automatisk peke på "her er forbindelsen!" — la spilleren selv legge merke til at formen på jordet, linjen i terrenget eller navnet på skiltet er gjenkjennelig fra det andre tidslaget.
3. **Kildekritikk som dialogvalg, ikke som fotnote.** Ved omdiskuterte tema (jf. Mære-eksempelet i `aha_moments.md` #9): gi spilleren et eksplisitt valg mellom "dette er dokumentert" og "dette er bare en historie folk forteller", med en kort forklaring uansett hvilket valg som tas — spilleren lærer kildekritikk ved å øve den, ikke ved å bli fortalt om den.
4. **Non-lineær oppdagelse.** Informasjon bør kunne nås fra flere retninger (jf. Outer Wilds-lærdommen) — spilleren som utforsker vikingtidslaget først og moderne-laget etterpå bør få en like sammenhengende opplevelse som den som gjør det motsatt.
5. **Korte møter, ikke infodump.** NPC-samtaler holdes korte og situasjonsbundne (jf. A Short Hike); dypere informasjon (kildehenvisning, lengre historisk kontekst) gjøres tilgjengelig *valgfritt* gjennom en egen "oppdagelses"-logg/kodex spilleren kan lese i eget tempo, ikke tvunget inn i hoveddialogen.
6. **Sikkerhetsgrad alltid synlig.** Følg `godot_mobile_technical_research.md`s forslag om en `Resource`-klasse for historiske faktapåstander med et sikkerhetsgrad-felt (fastslått/sannsynlig/omdiskutert/myte) — bruk dette konsekvent i UI, f.eks. som et lite, konsekvent ikon/fargekode ved siden av enhver "oppdaget fakta"-tekst.

---

## Del 2: Oppdragsidéer

### Oppdrag A — «Det jevne jordet» (basert på Gjellestad-typen, se `location_pairs.md` B1)
**Premiss:** En moderne gårdbruker-NPC nevner i forbifarten at traktoren alltid "hopper" på ett bestemt sted i jordet. Spilleren undersøker stedet i moderne-laget (ingen synlig anomali for det blotte øye — kun en NPC-antydning og kanskje et amatør-georadarbilde en lokal historieinteressert har tatt), bytter til vikingtidslaget, og oppdager en gårdsmakt med gravhaug/skipsgrav på nøyaktig samme flate.
**Miljøgåte:** Spilleren må først identifisere *nøyaktig* riktig flekk i moderne-laget (ved å legge merke til en svak forhøyning, en avvikende avlingsfarge, e.l.) før tidslagsbytte gir mening — ikke en tilfeldig "trykk hvor som helst"-mekanikk.
**Kildekritikk-element:** En kort tekst forklarer at dette fenomenet er reelt dokumentert ett sted i Norge (Gjellestad), men sjeldent — ikke normaltilstand.
**Sikkerhet:** Kategori c, høy (mønsteret er ekte; spillstedet er fiktivt).

### Oppdrag B — «To historier om kirken» (basert på Mære-typen, se `location_pairs.md` B2, `aha_moments.md` #9)
**Premiss:** En moderne kirkevert/lokalhistoriker-NPC forteller at "alle sier kirken vår står på et gammelt hedensk sted" — men vet ikke selv om det stemmer. Spilleren kan grave i kirkens historie (arkivbesøk, en gammel utgravningsrapport i moderne-laget) og i vikingtidslaget selv se om det faktisk lå et hov der.
**Miljøgåte:** To mulige utfall bygges inn strukturelt: på **ett** kirkested i spillet er koblingen dokumentert (Mære-modellen); på et **annet**, lignende kirkested i spillet er den udokumentert (bare en lokal fortelling) — spilleren lærer forskjellen ved selv å undersøke begge, ikke ved å bli fortalt fasiten på forhånd.
**Kildekritikk-element:** Eksplisitt dialogvalg: "dette er dokumentert" / "dette er bare en historie folk forteller" — begge kirkestedene gir spilleren riktig svar til slutt, uavhengig av hvilket valg som tas underveis, men med ulik begrunnelse.
**Sikkerhet:** Kategori c (dokumentert variant) / g (udokumentert variant), begge tydelig merket i spillteksten.

### Oppdrag C — «Veien som alltid har vært der» (basert på Bommestad-typen, se `location_pairs.md` B4)
**Premiss:** En syklist/turgåer-NPC i moderne-laget klager over at "veien alltid har gått akkurat her, selv om det ville vært kortere å legge den et annet sted". Spilleren følger en svak forsenkning i skogkanten ved siden av dagens vei, bytter tidslag, og ser den samme linjen som en trafikkert ferdselsåre med kjerrer og fotgjengere.
**Miljøgåte:** Ren observasjon/traversal — spilleren "leser" terrenget (en grønn linje i mosen, et brudd i skogen) i begge tidslag og kobler dem sammen selv.
**Sikkerhet:** Kategori c, middels-høy for fenomenet generelt.

### Oppdrag D — «Handelsplassen som ble stille» (basert på Kaupang-typen, se `location_pairs.md` B3)
**Premiss:** Spilleren finner i vikingtidslaget en yrende handelsby ved en beskyttet vik — utenlandske varer, mange språk, tett aktivitet. I moderne-laget er samme vik et stille, gressbevokst museumsområde. En moderne museumsvert-NPC kan fortelle at ingen helt vet hvorfor stedet ble forlatt.
**Miljøgåte/pedagogisk poeng:** Dette oppdraget er bevisst bygget for å **motbevise** en antagelse spilleren kanskje har fra tidligere oppdrag (at alle vikingtidssteder "blir til" moderne steder) — spilleren samler indisier (handelsvarer, brev/meldinger antydet i vikingtidslaget) uten at spillet gir et sikkert svar på *hvorfor* stedet ble forlatt, fordi det historisk sett faktisk er ukjent.
**Sikkerhet:** Kategori c, høy (for at stedet ble forlatt); spillet skal eksplisitt IKKE dikte opp en skråsikker årsak.

### Oppdrag E — «Navnet under navnet» (stedsnavn-gåte, se `aha_moments.md` #3)
**Premiss:** En språkinteressert NPC i moderne-laget (f.eks. en lokalhistorielags-entusiast) lurer på hva et stedsnavn "egentlig betyr". Spilleren samler stavelser/lydspor ved å utforske begge tidslag (et norrønt, gjennomsiktig navn brukt av NPC-er i vikingtidslaget; en lydlig forvitret form brukt i moderne-laget) og "løser" navnegåten selv, trinn for trinn.
**Kildekritikk-element:** Løsningen presenteres som "sannsynlig rekonstruksjon basert på navnegransking", ikke som 100 % sikker historie — siden spillets konkrete stedsnavn uansett er fiktive.
**Sikkerhet:** Kategori b, høy som metode.

### Oppdrag F — «Torsdagens gjest» (ukedagsnavn, se `aha_moments.md` #1)
**Premiss:** Et lavterskel, tidlig-i-spillet oppdrag: en moderne NPC nevner tilfeldig at "vi drar torsdag". Senere, i vikingtidslaget, observerer spilleren en utskåret figur eller et navngitt sted knyttet til Tor, uten at noen forklarer koblingen direkte — spilleren skal selv kjenne igjen "Tor" i "torsdag".
**Bruk:** God kandidat for spillets aller første "aha", fordi den krever null forkunnskap og er lett å bekrefte for spilleren selv.
**Sikkerhet:** Kategori b, høy.

### Oppdrag G — «Ekte vare?» (vegvísir-myteknuseren, se `location_pairs.md` B13, `aha_moments.md` #15)
**Premiss:** En moderne suvenirbutikk-NPC selger et "ekte, gammelt vikingsymbol" (vegvísir) med stor overbevisning. Spilleren kan ta med seg et bilde/en skisse av symbolet til vikingtidslaget og lete etter det — og finner det aldri, uansett hvor grundig man leter.
**Miljøgåte:** Et "negativt bevis"-oppdrag — spilleren lærer at fravær også er informasjon, ikke bare funn.
**Sikkerhet:** Kategori f, høy (godt dokumentert at symbolet er en 1800-tallskonstruksjon).

### Oppdrag H — «Tvisten på tinget» (ting → domstol, se `aha_moments.md` #5)
**Premiss:** I vikingtidslaget observerer/deltar spilleren i en enkel tvisteløsning på et lokalt ting (uten at spillet dramatiserer det som en rettsdramaserie eller lar spilleren "vinne" med våpen). I moderne-laget viser en domstolsbygning/rettssalskilt et navn som gjenkjennes fra tingstedet.
**Kildekritikk-element:** Eksplisitt tekst om at institusjonen har hatt et langt historisk brudd (dansketiden) — IKKE "norsk rettsvesen har fungert sammenhengende siden vikingtiden".
**Sikkerhet:** Kategori b/d, middels-høy.

### Oppdrag I — «Kollen i hagen» (gravhaug i moderne landskap, jf. Jæren/Borre-typen)
**Premiss:** En moderne huseier/gårdbruker-NPC nevner en "kul i plenen/jordet" de alltid har klippet rundt uten å tenke over det. Spilleren undersøker kollen, bytter tidslag, og ser den som en aktiv gravhaug i bruk.
**Miljøgåte:** Enkel, stedbunden observasjon — passer godt som et tidlig, lavterskel sideoppdrag som lærer spilleren tidslagsbytte-mekanikken.
**Sikkerhet:** Kategori c, høy for fenomenet generelt (gravhauger i moderne landskap er godt dokumentert flere steder).

### Oppdrag J — «Festen som forandret seg» (jul/midtvinter, valgfritt/sesongbasert)
**Premiss:** Spilleren opplever en midtvintersfest i vikingtidslaget og en julefeiring i moderne-laget på samme sted/tidspunkt på året, med en fortellerfigur (i vikingtidslaget) og en historielagsentusiast (i moderne-laget) som hver især antyder *deler* av sammenhengen, uten at noen av dem har hele bildet.
**Kildekritikk-element:** Bevisst IKKE et "vikingjul avslørt"-oppdrag — spillets tekst skal eksplisitt formidle at dette er et lagdelt, sammensatt fenomen (jf. `aha_moments.md` #16), ikke en enkel rett linje.
**Sikkerhet:** Kategori b+c+f kombinert, middels usikkerhet i detaljene — krever varsom formulering.

---

## Del 3: NPC-forslag (alle fiktive, kreativ frihet — inspirert av dokumenterte roller)

### Vikingtidslaget
- **Gårdskone / husfrue** — leder innendørsarbeid, tekstilproduksjon, matlaging; kan ha reell handlefrihet og eiendomsrett innen et formelt patriarkalsk samfunn (jf. `daily_life.md` 7.3). Fiktiv person, rolle dokumentert.
- **Smed/håndverker** — serieproduksjon av kammer/smykker (jf. `daily_life.md` 1.4); viser at håndverksvarer nådde bredere lag av befolkningen enn bare eliten.
- **Trell** — vises med verdighet og eget perspektiv (aldri kun som "kulisse"), med synlig, urettferdig arbeidsbyrde — aldri romantisert eller eksotisert (jf. `authenticity_and_sensitive_topics.md` 2.2). Viktig: skal ha stemme/dialog, ikke bare være en stum bakgrunnsfigur.
- **Reisende handelsmann** — bringer varer og nyheter fra andre deler av Norden/kontaktområder; naturlig kilde til "verden er større enn denne bygda"-informasjon uten infodump.
- **Lokal høvding/gårdseiers forvalter** — kan lede tinget/tvisteløsning i Oppdrag H; vises som del av et lagdelt, ikke egalitært samfunn.
- **Ung person i lære** — barn/ungdom med aldersrelevante oppgaver (jf. `daily_life.md` 8.1); gir spilleren en jevnaldrende å identifisere seg med i vikingtidslaget.

### Moderne-laget
- **Lokalhistorielags-entusiast** — kilden til stedsnavn-gåter (Oppdrag E) og "alle sier at..."-påstander som spilleren selv må undersøke (Oppdrag B).
- **Gårdbruker/huseier** — kilden til "kul i jordet"/"traktoren hopper her"-antydninger (Oppdrag A, I) — kjenner landskapet uten å kjenne historien bak det.
- **Museumsvert/kulturminnekonsulent** — kan gi dypere, valgfri kontekst (kodex-informasjon) uten å tvinge den inn i hoveddialogen; god kilde til eksplisitt kildekritikk-språk ("vi vet ikke sikkert hvorfor...").
- **Suvenirbutikk-eier** — naiv formidler av "ekte vikingsymboler" (Oppdrag G) — ikke ondsinnet, bare uinformert; gir et lavterskel myteknuser-øyeblikk uten å gjøre noen til skurk.
- **Domstolsarkivar/kommuneansatt** — kan forklare det institusjonelle bruddet i Oppdrag H på en kortfattet, ikke-forelesende måte (ett par setninger, ikke en historietime).
- **Barn/ungdom fra bygda** — kontrastfigur til den vikingtidsunge personen i lære; kan bli en visuell/tematisk kobling mellom tidslagene uten at spillet trenger å hardkode et slektskap.

---

## Del 4: Prinsipp for videre oppdragsdesign

Når flere oppdrag utvikles videre, bør hvert nytt oppdrag:
1. Kunne knyttes til minst én rad i `location_pairs.md` eller ett øyeblikk i `aha_moments.md` (ingen nye "historiske fakta" skal oppfinnes direkte i oppdragsdesign uten å gå veien om `docs/research/`).
2. Ha et eksplisitt, dokumentert svar på "hvordan oppdager spilleren dette selv, uten å bli fortalt det?" før oppdraget bygges.
3. Merkes med sikkerhetsgrad (a–g) i eget produksjonsnotat, slik at senere innholdsforfattere kan bruke `Resource`-klassen for historiske faktapåstander foreslått i `research/godot_mobile_technical_research.md` konsekvent.
