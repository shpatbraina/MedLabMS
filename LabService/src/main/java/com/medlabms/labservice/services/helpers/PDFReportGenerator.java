package com.medlabms.labservice.services.helpers;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPageEventHelper;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;
import com.medlabms.labservice.models.dtos.PatientDTO;
import com.medlabms.labservice.models.dtos.VisitAnalysisDTO;
import com.medlabms.labservice.models.entities.Visit;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Slf4j
@Component
public class PDFReportGenerator {

    public ByteArrayInputStream generateVisitAnalysesPDF(Visit visit, PatientDTO patient, List<VisitAnalysisDTO> analyses) {
        Document document = new Document(PageSize.A4, 40, 40, 50, 50);
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        try {
            PdfWriter writer = PdfWriter.getInstance(document, out);
            writer.setPageEvent(new FooterPageEvent());
            document.open();

            addHeader(document); // Modern header with logo + title

            // Patient metadata
            Font metaFont = new Font(Font.FontFamily.HELVETICA, 11, Font.NORMAL, BaseColor.DARK_GRAY);
            Paragraph metadata = new Paragraph(String.format("Patient: %s    |    Visit Date: %s",
                    patient.getFullName(), visit.getDateOfVisit()), metaFont);
            metadata.setSpacingAfter(15f);
            document.add(metadata);

            // Grouping
            Map<String, List<VisitAnalysisDTO>> grouped = analyses.stream()
                    .collect(Collectors.groupingBy(VisitAnalysisDTO::getAnalysisGroupName));

            for (Map.Entry<String, List<VisitAnalysisDTO>> entry : grouped.entrySet()) {
                String groupName = entry.getKey();
                List<VisitAnalysisDTO> groupAnalyses = entry.getValue();

                Font groupFont = new Font(Font.FontFamily.HELVETICA, 13, Font.BOLD, new BaseColor(52, 58, 64));
                Paragraph groupTitle = new Paragraph(groupName, groupFont);
                groupTitle.setSpacingBefore(20f);
                groupTitle.setSpacingAfter(10f);
                document.add(groupTitle);

                PdfPTable table = new PdfPTable(5);
                table.setWidthPercentage(100);
                table.setWidths(new float[]{1f, 3f, 2f, 2f, 3f});
                table.setSpacingBefore(5f);
                table.setSpacingAfter(15f);

                Font headerFont = new Font(Font.FontFamily.HELVETICA, 11, Font.BOLD, BaseColor.WHITE);
                Stream.of("ID", "Name", "Value", "Metric", "Range").forEach(col -> {
                    PdfPCell header = new PdfPCell(new Phrase(col, headerFont));
                    header.setBackgroundColor(new BaseColor(220, 53, 69));
                    header.setHorizontalAlignment(Element.ALIGN_CENTER);
                    header.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    header.setPadding(6f);
                    table.addCell(header);
                });

                boolean alternate = false;
                BaseColor altRowColor = new BaseColor(245, 245, 245);

                for (VisitAnalysisDTO va : groupAnalyses) {
                    BaseColor bg = alternate ? altRowColor : BaseColor.WHITE;
                    alternate = !alternate;

                    table.addCell(createStyledCell(String.valueOf(va.getId()), bg));
                    table.addCell(createStyledCell(va.getName(), bg));

                    PdfPCell valueCell = createStyledCell(va.getValue(), bg);
                    try {
                        double val = Double.parseDouble(va.getValue());
                        double[] range = parseRange(va.getMetricRange());
                        if (!Double.isNaN(range[0]) && val < range[0] || !Double.isNaN(range[1]) && val > range[1]) {
                            valueCell.setBackgroundColor(new BaseColor(255, 204, 204));
                        }
                    } catch (Exception ignored) {}

                    table.addCell(valueCell);
                    table.addCell(createStyledCell(va.getMetric(), bg));
                    table.addCell(createStyledCell(va.getMetricRange(), bg));
                }

                document.add(table);
            }

            document.close();
        } catch (Exception e) {
            log.error("Error generating PDF", e);
        }

        return new ByteArrayInputStream(out.toByteArray());
    }

    private void addHeader(Document document) throws IOException, DocumentException {
        PdfPTable headerTable = new PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.setWidths(new float[]{1.5f, 6.5f}); // Large logo area

        URL logoUrl = getClass().getClassLoader().getResource("cropped.png");
        PdfPCell logoCell;
        if (logoUrl != null) {
            Image logo = Image.getInstance(logoUrl);
            logo.scaleAbsolute(90, 50); // BIG visual block
            logo.setAlignment(Image.ALIGN_LEFT);
            logoCell = new PdfPCell(logo);
        } else {
            logoCell = new PdfPCell(new Phrase(""));
        }
        logoCell.setBorder(Rectangle.NO_BORDER);
        logoCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        logoCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        headerTable.addCell(logoCell);

        Font labFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, new BaseColor(33, 37, 41));
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD, new BaseColor(52, 58, 64));
        Paragraph titleBlock = new Paragraph();
        titleBlock.add(new Phrase("MedLab Diagnostics\n", labFont));
        titleBlock.add(new Phrase("Visit Analyses Report", titleFont));

        PdfPCell titleCell = new PdfPCell(titleBlock);
        titleCell.setBorder(Rectangle.NO_BORDER);
        titleCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        titleCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        headerTable.addCell(titleCell);

        document.add(headerTable);
        document.add(new Chunk(new LineSeparator(1f, 100f, new BaseColor(200, 200, 200), Element.ALIGN_CENTER, -2)));
        document.add(Chunk.NEWLINE);
    }

    private PdfPCell createStyledCell(String text, BaseColor bg) {
        Font font = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.BLACK);
        PdfPCell cell = new PdfPCell(new Phrase(text != null ? text : "", font));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        cell.setBackgroundColor(bg);
        cell.setPadding(5f);
        return cell;
    }

    private double[] parseRange(String range) {
        if (range == null) return new double[]{Double.NaN, Double.NaN};
        Matcher m1 = Pattern.compile("min\\s*[><=]?\\s*(\\d+(\\.\\d+)?)").matcher(range);
        Matcher m2 = Pattern.compile("max\\s*[><=]?\\s*(\\d+(\\.\\d+)?)").matcher(range);
        Matcher dash = Pattern.compile("(\\d+(\\.\\d+)?)\\s*-\\s*(\\d+(\\.\\d+)?)").matcher(range);
        Matcher words = Pattern.compile("range:?\\s*(\\d+(\\.\\d+)?)\\s*to\\s*(\\d+(\\.\\d+)?)", Pattern.CASE_INSENSITIVE).matcher(range);

        if (m1.find() && m2.find()) return new double[]{Double.parseDouble(m1.group(1)), Double.parseDouble(m2.group(1))};
        if (dash.find()) return new double[]{Double.parseDouble(dash.group(1)), Double.parseDouble(dash.group(3))};
        if (words.find()) return new double[]{Double.parseDouble(words.group(1)), Double.parseDouble(words.group(3))};
        return new double[]{Double.NaN, Double.NaN};
    }

    static class FooterPageEvent extends PdfPageEventHelper {
        Font font = new Font(Font.FontFamily.HELVETICA, 9, Font.NORMAL, new BaseColor(120, 120, 120));
        Font bold = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD);

        @Override
        public void onEndPage(PdfWriter writer, Document document) {
            PdfPTable footer = new PdfPTable(3);
            try {
                footer.setWidths(new float[]{3, 2, 3});
                footer.setTotalWidth(527);
                footer.setLockedWidth(true);

                PdfPCell left = new PdfPCell(new Phrase("📍 Prishtinë   |   +383 44 123 456   |   info@medlab.com", font));
                PdfPCell center = new PdfPCell(new Phrase("Page " + writer.getPageNumber(), bold));
                PdfPCell right = new PdfPCell(new Phrase("Digitally signed\nDr. Shpat Braina", font));

                for (PdfPCell cell : Arrays.asList(left, center, right)) {
                    cell.setBorder(Rectangle.TOP);
                    cell.setPaddingTop(5);
                    cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                }

                left.setHorizontalAlignment(Element.ALIGN_LEFT);
                center.setHorizontalAlignment(Element.ALIGN_CENTER);
                right.setHorizontalAlignment(Element.ALIGN_RIGHT);

                footer.addCell(left);
                footer.addCell(center);
                footer.addCell(right);

                footer.writeSelectedRows(0, -1, 34, 50, writer.getDirectContent());
            } catch (Exception e) {
                throw new ExceptionConverter(e);
            }
        }
    }
}
