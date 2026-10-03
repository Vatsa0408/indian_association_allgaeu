import 'package:flutter/material.dart';

// Bilingual values are [en, de] pairs; pick with tr().
String tr(List<String> pair, String lang) => pair[lang == 'de' ? 1 : 0];

class Event {
  final String id, category, status, location;
  final List<String> title, date, desc;
  final String? registerUrl; // Google Forms link, upcoming events only
  const Event(
    this.id,
    this.category,
    this.status,
    this.title,
    this.date,
    this.location,
    this.desc, {
    this.registerUrl,
  });
}

const events = [
  Event(
    'diwali26',
    'Diwali',
    'upcoming',
    ['Diwali 2026', 'Diwali 2026'],
    ['Sat, 17 Oct 2026', 'Sa., 17. Okt. 2026'],
    'St Franiskus, 87435, Kempten',
    [
      'Lights, food stalls, dance performances and a community dinner to celebrate the festival of lights.',
      'Lichter, Essensstände, Tanzaufführungen und ein gemeinsames Abendessen zum Lichterfest.',
    ],
    // TODO: placeholder, replace with the real Google Forms link
    registerUrl: 'https://forms.gle/2dn4VTgGxJdJe6Vb6',
  ),
];

// Key order = gallery filter chip order.
const categoryLabel = {
  'Diwali': ['Diwali', 'Diwali'],
};

// One entry per gallery photo (its category).
const galleryPhotos = ['Diwali', 'Diwali', 'Diwali'];

const committee = [
  ('Arvind Menon', ['President', 'Vorsitzender']),
  ('Priya Nair', ['Vice President', 'Stellv. Vorsitzende']),
  ('Rohit Sharma', ['Secretary', 'Schriftführer']),
  ('Kavita Iyer', ['Treasurer', 'Kassenwartin']),
  ('Sanjay Gupta', ['Cultural Coordinator', 'Kulturreferent']),
  ('Meera Krishnan', ['Events Coordinator', 'Eventkoordinatorin']),
  ('Anil Deshpande', ['Media & Communications', 'Medien & Kommunikation']),
  ('Divya Rao', ['Youth Coordinator', 'Jugendreferentin']),
];

const social = [
  (Icons.photo_camera, 'https://instagram.com/'),
  (Icons.thumb_up, 'https://facebook.com/'),
  (Icons.smart_display, 'https://youtube.com/'),
  (Icons.public, 'https://example.org/'),
];

const whatsappUrl = 'https://chat.whatsapp.com/Be3ceUFL1R03qCXri1WnIr';
const paypalUrl = 'https://paypal.me/';

const fee = ['€30 / year (family €45)', '30 € / Jahr (Familie 45 €)'];

const bank = {
  'Account': 'Indian Association Allgäu e.V.',
  'IBAN': 'DE12 3456 7890 1234 5678 90',
  'BIC': 'GENODEF1KEM',
  'Bank': 'Sparkasse Allgäu',
};

const benefits = [
  [
    'Free entry to most events',
    'Freier Eintritt zu den meisten Veranstaltungen',
  ],
  [
    'Voting rights at the general meeting',
    'Stimmrecht bei der Mitgliederversammlung',
  ],
  ['Discounted tickets for festivals', 'Vergünstigte Tickets für Feste'],
  ["Access to the members' directory", 'Zugang zum Mitgliederverzeichnis'],
];

const strings = {
  'appName': ['IAA Allgäu', 'IAA Allgäu'],
  'navHome': ['Home', 'Start'],
  'navEvents': ['Events', 'Events'],
  'navGallery': ['Gallery', 'Galerie'],
  'navContact': ['Contact', 'Kontakt'],
  'navMore': ['More', 'Mehr'],
  'aboutAppBody': [
    'The community app of the Indian Association Allgäu: events, photos and ways to get in touch.',
    'Die Community-App des Indian Association Allgäu: Veranstaltungen, Fotos und Kontaktmöglichkeiten.',
  ],
  'heroTagline': [
    'A home for Indian culture in the Allgäu',
    'Ein Zuhause für indische Kultur im Allgäu',
  ],
  'aboutHeading': ['About us', 'Über uns'],
  'aboutBody': [
    'Indian Association Allgäu brings together Indian families and friends of India living across the Allgäu region. We organise festivals, cultural evenings and community gatherings, and support newcomers settling into the area.',
    'Der Indian Association Allgäu bringt indische Familien und Freunde Indiens im Allgäu zusammen. Wir veranstalten Feste, kulturelle Abende und Gemeinschaftstreffen und unterstützen Neuankömmlinge beim Einleben in der Region.',
  ],
  'quickJoinWhatsapp': ['Join WhatsApp group', 'WhatsApp-Gruppe beitreten'],
  'quickBecomeMember': ['Become a member', 'Mitglied werden'],
  'upcomingHeading': ['Coming up', 'Demnächst'],
  'seeAllEvents': ['See all events', 'Alle Events ansehen'],
  'quickLinksHeading': ['Find us online', 'Folgt uns online'],
  'filterUpcoming': ['Upcoming', 'Kommend'],
  'filterPast': ['Past', 'Vergangen'],
  'eventsHeading': ['Events', 'Events'],
  'dateLabel': ['Date', 'Datum'],
  'locationLabel': ['Location', 'Ort'],
  'aboutEventHeading': ['About this event', 'Über diese Veranstaltung'],
  'registerCta': [
    'Register for this event',
    'Für diese Veranstaltung anmelden',
  ],
  'galleryHeading': ['Gallery', 'Galerie'],
  'galleryFilterAll': ['All', 'Alle'],
  'contactHeading': ['Contact', 'Kontakt'],
  'whatsappBannerTitle': [
    'Community WhatsApp Group',
    'WhatsApp-Gruppe der Gemeinschaft',
  ],
  'whatsappBannerBody': [
    'Get event reminders and updates. Everyone is welcome.',
    'Erhalte Erinnerungen und Neuigkeiten zu Events. Jeder ist willkommen.',
  ],
  'whatsappCta': ['Open WhatsApp', 'WhatsApp öffnen'],
  'committeeHeading': ['Committee', 'Vorstand'],
  'socialHeading': ['Follow us', 'Folgt uns'],
  'moreHeading': ['More', 'Mehr'],
  'membershipHeading': ['Membership', 'Mitgliedschaft'],
  'membershipFeeLabel': ['Annual fee', 'Jahresbeitrag'],
  'membershipBenefitsHeading': ['Member benefits', 'Vorteile für Mitglieder'],
  'membershipHowHeading': ['How to join', 'So wirst du Mitglied'],
  'membershipHowBody': [
    'Contact any committee member or write to us on WhatsApp, and we will send you the membership form and bank details.',
    'Sprich ein Vorstandsmitglied an oder schreib uns über WhatsApp, wir schicken dir das Anmeldeformular und die Bankdaten.',
  ],
  'donationsHeading': ['Donations', 'Spenden'],
  'donationsBody': [
    'The association runs entirely on volunteer work and member contributions. Any donation helps us host bigger festivals and support families in need.',
    'Der Verein finanziert sich vollständig durch ehrenamtliche Arbeit und Mitgliedsbeiträge. Jede Spende hilft uns, größere Feste zu veranstalten und Familien in Not zu unterstützen.',
  ],
  'bankTransferHeading': ['Bank transfer', 'Banküberweisung'],
  'paypalHeading': ['PayPal', 'PayPal'],
  'paypalCta': ['Donate via PayPal', 'Über PayPal spenden'],
  'imprintHeading': ['About the association', 'Über den Verein'],
  'imprintBody': [
    'Indian Association Allgäu e.V. is a registered non-profit association based in Kempten, Bavaria.',
    'Indian Association Allgäu e.V. ist ein eingetragener, gemeinnütziger Verein mit Sitz in Kempten, Bayern.',
  ],
};
