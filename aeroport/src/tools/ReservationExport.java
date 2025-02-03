package tools;

import java.io.ByteArrayOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

import com.itextpdf.kernel.colors.Color;
import com.itextpdf.kernel.colors.DeviceRgb;
import com.itextpdf.kernel.geom.PageSize;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.borders.Border;
import com.itextpdf.layout.borders.SolidBorder;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Div;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.property.TextAlignment;
import com.itextpdf.layout.property.UnitValue;

import aeroport.reservation.Reservation;
import aeroport.vol.Vol;
import mg.itu.utils.Exportation;

public class ReservationExport extends Exportation {
    Reservation reservation;
    
    // Couleurs pour le design moderne
    private static final Color PRIMARY_COLOR = new DeviceRgb(102, 126, 234);  // Bleu-violet
    private static final Color SECONDARY_COLOR = new DeviceRgb(118, 75, 162); // Violet
    private static final Color LIGHT_GRAY = new DeviceRgb(248, 249, 250);
    private static final Color MEDIUM_GRAY = new DeviceRgb(233, 236, 239);
    private static final Color DARK_GRAY = new DeviceRgb(52, 58, 64);
    private static final Color SUCCESS_COLOR = new DeviceRgb(40, 167, 69);
    private static final Color WARNING_COLOR = new DeviceRgb(255, 193, 7);
    private static final Color INFO_BG = new DeviceRgb(240, 242, 247);

    public Reservation getReservation() {
        return reservation;
    }

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public void export() throws Exception {
        switch (this.getType()) {
            case "pdf":
                this.setBytes(exportPDF());
                break;
            case "csv":
                this.setBytes(exportCSV());
                break;
            default:
                throw new Exception("Le format demandé ne peut être résolu.");
        }
    }

    private byte[] exportPDF() throws Exception {
        ByteArrayOutputStream output = new ByteArrayOutputStream();

        try (PdfWriter writer = new PdfWriter(output);
             PdfDocument pdf = new PdfDocument(writer);
             Document document = new Document(pdf, PageSize.A4)) {

            // Configuration des marges pour un meilleur rendu
            document.setMargins(40, 40, 40, 40);

            // ===== EN-TÊTE STYLISÉ =====
            addStyledHeader(document);
            
            // ===== NUMÉRO DE RÉSERVATION MIS EN ÉVIDENCE =====
            addReservationNumberBox(document);
            
            // ===== INFORMATIONS CLIENT ET PASSAGERS =====
            addPassengerSection(document);
            
            // ===== DÉTAILS DU VOL =====
            addFlightDetailsSection(document);
            
            // ===== MONTANT TOTAL =====
            addPriceSection(document);
            
            // ===== INFORMATIONS IMPORTANTES =====
            addImportantInfo(document);
            
            // ===== PIED DE PAGE =====
            addFooter(document);

            document.close();
            return output.toByteArray();
        }
    }
    
    private void addStyledHeader(Document document) {
        // Container principal pour l'en-tête avec fond coloré
        Table headerTable = new Table(UnitValue.createPercentArray(1))
            .setWidth(UnitValue.createPercentValue(100))
            .setBackgroundColor(PRIMARY_COLOR)
            .setMarginBottom(25);
        
        Cell headerCell = new Cell()
            .setBorder(Border.NO_BORDER)
            .setPadding(30);
        
        // Icône avion (simulée avec du texte)
        Paragraph icon = new Paragraph("✈")
            .setFontSize(45)
            .setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE)
            .setTextAlignment(TextAlignment.CENTER)
            .setMarginBottom(10);
        
        // Nom de la compagnie
        Paragraph companyName = new Paragraph("AEROPORT")
            .setFontSize(28)
            .setBold()
            .setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE)
            .setTextAlignment(TextAlignment.CENTER)
            .setMarginBottom(5);
        
        // Sous-titre
        Paragraph subtitle = new Paragraph("CONFIRMATION DE RÉSERVATION")
            .setFontSize(14)
            .setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE)
            .setTextAlignment(TextAlignment.CENTER)
            .setMarginBottom(5);
        
        // Date d'émission
        Paragraph date = new Paragraph("Document émis le " + new java.text.SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()))
            .setFontSize(10)
            .setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE)
            .setTextAlignment(TextAlignment.CENTER)
            .setItalic();
        
        headerCell.add(icon);
        headerCell.add(companyName);
        headerCell.add(subtitle);
        headerCell.add(date);
        
        headerTable.addCell(headerCell);
        document.add(headerTable);
    }
    
    private void addReservationNumberBox(Document document) {
        Table reservTable = new Table(UnitValue.createPercentArray(1))
            .setWidth(UnitValue.createPercentValue(100))
            .setMarginBottom(20);
        
        Cell reservCell = new Cell()
            .setBackgroundColor(LIGHT_GRAY)
            .setBorder(new SolidBorder(PRIMARY_COLOR, 2))
            .setPadding(15);
        
        Paragraph label = new Paragraph("NUMÉRO DE RÉSERVATION")
            .setFontSize(10)
            .setFontColor(DARK_GRAY)
            .setTextAlignment(TextAlignment.CENTER);
        
        Paragraph number = new Paragraph(reservation.getIdReservation())
            .setFontSize(20)
            .setBold()
            .setFontColor(PRIMARY_COLOR)
            .setTextAlignment(TextAlignment.CENTER);
        
        reservCell.add(label);
        reservCell.add(number);
        
        reservTable.addCell(reservCell);
        document.add(reservTable);
    }
    
    private void addPassengerSection(Document document) throws Exception {
        // Titre de section avec style
        addSectionTitle(document, "INFORMATIONS PASSAGERS");
        
        // Table pour les informations
        Table infoTable = new Table(UnitValue.createPercentArray(new float[]{35, 65}))
            .setWidth(UnitValue.createPercentValue(100))
            .setMarginBottom(20);
        
        // Client
        String clientName = (reservation.getCli() != null && reservation.getCli().getNom() != null) 
            ? reservation.getCli().getNom() + " " + reservation.getCli().getPrenom()
            : "Client Particulier";
        addStyledTableRow(infoTable, "Client", clientName);
        
        // Date de réservation
        addStyledTableRow(infoTable, "Date de réservation", reservation.getDateString());
        
        // Nombre de passagers avec icônes
        String adultes = reservation.getNbAdulte() + " adulte" + (reservation.getNbAdulte() > 1 ? "s" : "");
        String enfants = reservation.getNbEnfant() + " enfant" + (reservation.getNbEnfant() > 1 ? "s" : "");
        addStyledTableRow(infoTable, "Passagers", adultes + " | " + enfants);
        
        // Classe avec badge
        String classe = reservation.getClasse().toUpperCase();
        addStyledTableRow(infoTable, "Classe", classe);
        
        document.add(infoTable);
    }
    
    private void addFlightDetailsSection(Document document) throws Exception {
        Vol v = reservation.getVol();
        
        // Titre de section
        addSectionTitle(document, "DÉTAILS DU VOL");
        
        // Carte du trajet avec style
        Table routeTable = new Table(UnitValue.createPercentArray(1))
            .setWidth(UnitValue.createPercentValue(100))
            .setMarginBottom(15);
        
        Cell routeCell = new Cell()
            .setBackgroundColor(INFO_BG)
            .setBorder(Border.NO_BORDER)
            .setPadding(20);
        
        // Trajet principal
        Table routeContent = new Table(UnitValue.createPercentArray(new float[]{40, 20, 40}))
            .setWidth(UnitValue.createPercentValue(100));
        
        Cell departCell = new Cell()
            .add(new Paragraph(v.getDepartV())
                .setFontSize(18)
                .setBold()
                .setFontColor(PRIMARY_COLOR)
                .setTextAlignment(TextAlignment.RIGHT))
            .setBorder(Border.NO_BORDER);
        
        Cell arrowCell = new Cell()
            .add(new Paragraph("→")
                .setFontSize(24)
                .setFontColor(SECONDARY_COLOR)
                .setTextAlignment(TextAlignment.CENTER))
            .setBorder(Border.NO_BORDER);
        
        Cell arrivalCell = new Cell()
            .add(new Paragraph(v.getDestinationV())
                .setFontSize(18)
                .setBold()
                .setFontColor(PRIMARY_COLOR)
                .setTextAlignment(TextAlignment.LEFT))
            .setBorder(Border.NO_BORDER);
        
        routeContent.addCell(departCell);
        routeContent.addCell(arrowCell);
        routeContent.addCell(arrivalCell);
        
        routeCell.add(routeContent);
        
        // Numéro de vol centré
        Paragraph flightNumber = new Paragraph("Vol " + v.getIdVol())
            .setFontSize(12)
            .setFontColor(DARK_GRAY)
            .setTextAlignment(TextAlignment.CENTER)
            .setMarginTop(10);
        
        routeCell.add(flightNumber);
        routeTable.addCell(routeCell);
        document.add(routeTable);
        
        // Détails supplémentaires
        Table detailsTable = new Table(UnitValue.createPercentArray(new float[]{35, 65}))
            .setWidth(UnitValue.createPercentValue(100))
            .setMarginBottom(20);
        
        addStyledTableRow(detailsTable, "Date de départ", v.getDateString());
        addStyledTableRow(detailsTable, "Durée du vol", v.getDureeV());
        
        document.add(detailsTable);
    }
    
    private void addPriceSection(Document document) throws Exception {
        // Container pour le prix avec style attractif
        Table priceTable = new Table(UnitValue.createPercentArray(1))
            .setWidth(UnitValue.createPercentValue(100))
            .setMarginBottom(20);
        
        Cell priceCell = new Cell()
            .setBackgroundColor(SUCCESS_COLOR)
            .setBorder(Border.NO_BORDER)
            .setPadding(20);
        
        Paragraph priceLabel = new Paragraph("MONTANT TOTAL")
            .setFontSize(12)
            .setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE)
            .setTextAlignment(TextAlignment.CENTER)
            .setMarginBottom(5);
        
        Paragraph priceAmount = new Paragraph(String.format("%.2f EUR", reservation.getTarif()))
            .setFontSize(28)
            .setBold()
            .setFontColor(com.itextpdf.kernel.colors.ColorConstants.WHITE)
            .setTextAlignment(TextAlignment.CENTER);
        
        priceCell.add(priceLabel);
        priceCell.add(priceAmount);
        
        priceTable.addCell(priceCell);
        document.add(priceTable);
    }
    
    private void addImportantInfo(Document document) {
        Table infoTable = new Table(UnitValue.createPercentArray(1))
            .setWidth(UnitValue.createPercentValue(100))
            .setMarginBottom(20);
        
        Cell infoCell = new Cell()
            .setBackgroundColor(new DeviceRgb(255, 251, 235))
            .setBorder(new SolidBorder(WARNING_COLOR, 1))
            .setPadding(15);
        
        Paragraph infoTitle = new Paragraph("⚠ INFORMATIONS IMPORTANTES")
            .setFontSize(11)
            .setBold()
            .setFontColor(new DeviceRgb(133, 100, 4))
            .setMarginBottom(8);
        
        Paragraph info1 = new Paragraph("• Présentez-vous à l'aéroport au moins 2 heures avant le départ")
            .setFontSize(10)
            .setFontColor(new DeviceRgb(133, 100, 4));
        
        Paragraph info2 = new Paragraph("• Munissez-vous de vos pièces d'identité valides")
            .setFontSize(10)
            .setFontColor(new DeviceRgb(133, 100, 4));
        
        Paragraph info3 = new Paragraph("• Ce document ne constitue pas un billet d'embarquement")
            .setFontSize(10)
            .setFontColor(new DeviceRgb(133, 100, 4));
        
        infoCell.add(infoTitle);
        infoCell.add(info1);
        infoCell.add(info2);
        infoCell.add(info3);
        
        infoTable.addCell(infoCell);
        document.add(infoTable);
    }
    
    private void addFooter(Document document) {
        Paragraph separator = new Paragraph("─────────────────────────────────")
            .setFontColor(MEDIUM_GRAY)
            .setTextAlignment(TextAlignment.CENTER)
            .setMarginTop(20)
            .setMarginBottom(10);
        
        Paragraph thanks = new Paragraph("Merci de votre confiance. Bon voyage !")
            .setFontSize(11)
            .setFontColor(DARK_GRAY)
            .setTextAlignment(TextAlignment.CENTER)
            .setBold()
            .setMarginBottom(5);
        
        Paragraph contact = new Paragraph("Pour toute question : contact@aeroport.mg | +261 20 XX XXX XX")
            .setFontSize(9)
            .setFontColor(new DeviceRgb(108, 117, 125))
            .setTextAlignment(TextAlignment.CENTER)
            .setMarginBottom(3);
        
        Paragraph website = new Paragraph("www.aeroport.mg")
            .setFontSize(9)
            .setFontColor(PRIMARY_COLOR)
            .setTextAlignment(TextAlignment.CENTER);
        
        document.add(separator);
        document.add(thanks);
        document.add(contact);
        document.add(website);
    }
    
    private void addSectionTitle(Document document, String title) {
        Paragraph sectionTitle = new Paragraph(title)
            .setFontSize(13)
            .setBold()
            .setFontColor(DARK_GRAY)
            .setMarginBottom(10)
            .setPaddingBottom(5)
            .setBorderBottom(new SolidBorder(PRIMARY_COLOR, 2));
        document.add(sectionTitle);
    }
    
    private void addStyledTableRow(Table table, String label, String value) {
        Cell labelCell = new Cell()
            .add(new Paragraph(label)
                .setFontSize(10)
                .setFontColor(DARK_GRAY)
                .setBold())
            .setBackgroundColor(LIGHT_GRAY)
            .setBorder(Border.NO_BORDER)
            .setPadding(10)
            .setPaddingLeft(15);
        
        Cell valueCell = new Cell()
            .add(new Paragraph(value)
                .setFontSize(11)
                .setFontColor(DARK_GRAY))
            .setBorder(Border.NO_BORDER)
            .setPadding(10)
            .setPaddingLeft(15);
        
        table.addCell(labelCell);
        table.addCell(valueCell);
    }

    private byte[] exportCSV() throws Exception {
        ByteArrayOutputStream outputStream = null;
        PrintWriter writer = null;

        try {
            outputStream = new ByteArrayOutputStream();
            writer = new PrintWriter(new OutputStreamWriter(outputStream, StandardCharsets.UTF_8));

            Vol v = reservation.getVol();
            String depart = v.getDepartV();
            String arrivee = v.getDestinationV();
            String date = v.getDateString();
            
            String clientName = (reservation.getCli() != null && reservation.getCli().getNom() != null) 
                ? reservation.getCli().getNom() + " " + reservation.getCli().getPrenom()
                : "Particulier";

            // En-tête amélioré
            writer.println("id_reservation,client,classe,nb_enfant,nb_adulte,date_reservation,id_client,vol,depart,destination,date_depart,duree,montant");

            // Données
            writer.println(String.format("%s,%s,%s,%d,%d,%s,%s,%s,%s,%s,%s,%s,%.2f",
                reservation.getIdReservation(),
                clientName,
                reservation.getClasse(),
                reservation.getNbEnfant(),
                reservation.getNbAdulte(),
                reservation.getDateString(),
                reservation.getIdClient(),
                v.getIdVol(),
                depart,
                arrivee,
                date,
                v.getDureeV(),
                reservation.getTarif()));

            writer.flush();
            return outputStream.toByteArray();
        } finally {
            if (writer != null) writer.close();
            if (outputStream != null) outputStream.close();
        }
    }
}