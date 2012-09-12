/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.aria.edu.symrec.gui;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.aria.edu.symrec.gui.SymbolCanvas.SymbolPoint;

import SymbolRecognitionTest.*;
import SymbolTesting2.*;
import com.mathworks.toolbox.javabuilder.*;
import java.text.DecimalFormat;

/**
 *
 * @author alex
 */
public class SymbolRecognition extends javax.swing.JFrame {

    /**
     * Creates new form SymbolRecognition
     */
    public SymbolRecognition() {
        initComponents();
        
        // initialize symbolTrackerMap 
        symbolTrackerMap = new HashMap<String, Map<String, List<List<SymbolPoint>>>>();
        for (int i = 0; i < symbolNameSelector.getItemCount(); i++) {
            String symbolName = (String)symbolNameSelector.getItemAt(i);
            Map<String, List<List<SymbolPoint>>> symbolPurposeMap = new HashMap<String, List<List<SymbolPoint>>>();
            
            for (int j = 0; j < symbolPurposeSelector.getItemCount(); j++) {
                String symbolPurpose = (String)symbolPurposeSelector.getItemAt(j);
                symbolPurposeMap.put(symbolPurpose, new ArrayList<List<SymbolPoint>>());
            }
            
            symbolTrackerMap.put(symbolName, symbolPurposeMap);
        }
        
        // set observation text area for symbol canvas
        symbolRecordPad.setObsTextArea(symbolObservationText);
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        symbolTabManager = new javax.swing.JTabbedPane();
        symbolRecordPanel = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        symbolClearButton = new javax.swing.JButton();
        symbolRecordPad = new org.aria.edu.symrec.gui.SymbolCanvas();
        jLabel2 = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        symbolNameSelector = new javax.swing.JComboBox();
        jScrollPane1 = new javax.swing.JScrollPane();
        symbolObservationText = new javax.swing.JTextArea();
        symbolSaveButton = new javax.swing.JButton();
        symbolPurposeSelector = new javax.swing.JComboBox();
        jLabel4 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();
        symbolBrowsePanel = new javax.swing.JPanel();
        symbolRecognizePanel = new javax.swing.JPanel();
        jLabel5 = new javax.swing.JLabel();
        symbolRecognizePad = new org.aria.edu.symrec.gui.SymbolCanvas();
        symbolTestButton = new javax.swing.JButton();
        symbolClearTestButton = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();
        symbolHMMTransitionSelector = new javax.swing.JComboBox();
        symbolRecognizedLabel = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        symbolRecognizeObsText = new javax.swing.JTextArea();
        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenu2 = new javax.swing.JMenu();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setFont(new java.awt.Font("DejaVu Sans", 1, 12)); // NOI18N
        setResizable(false);

        symbolTabManager.setBorder(javax.swing.BorderFactory.createEtchedBorder());
        symbolTabManager.setName("null"); // NOI18N

        jLabel3.setFont(new java.awt.Font("DejaVu Sans", 1, 12)); // NOI18N
        jLabel3.setText("Draw symbol here");

        symbolClearButton.setLabel("Clear");
        symbolClearButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                symbolClearButtonMouseClicked(evt);
            }
        });

        symbolRecordPad.setBackground(new java.awt.Color(249, 247, 244));
        symbolRecordPad.setName("symbolRecordPad"); // NOI18N

        jLabel2.setFont(new java.awt.Font("DejaVu Sans", 1, 12)); // NOI18N
        jLabel2.setText("Observations");

        jLabel1.setBackground(new java.awt.Color(145, 159, 174));
        jLabel1.setFont(new java.awt.Font("DejaVu Sans", 1, 12)); // NOI18N
        jLabel1.setText("Select Symbol Type");

        symbolNameSelector.setMaximumRowCount(6);
        symbolNameSelector.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "left_arrow", "right_arrow", "circle", "square", "infinity" }));

        symbolObservationText.setEditable(false);
        symbolObservationText.setColumns(20);
        symbolObservationText.setRows(5);
        jScrollPane1.setViewportView(symbolObservationText);

        symbolSaveButton.setText("Save");
        symbolSaveButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                symbolSaveButtonMouseClicked(evt);
            }
        });

        symbolPurposeSelector.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "train", "validate", "test" }));

        jLabel4.setFont(new java.awt.Font("DejaVu Sans", 1, 12)); // NOI18N
        jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel4.setText("Select Symbol Purpose");

        jButton1.setText("Export Symbols");

        javax.swing.GroupLayout symbolRecordPanelLayout = new javax.swing.GroupLayout(symbolRecordPanel);
        symbolRecordPanel.setLayout(symbolRecordPanelLayout);
        symbolRecordPanelLayout.setHorizontalGroup(
            symbolRecordPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(symbolRecordPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(symbolRecordPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(symbolRecordPanelLayout.createSequentialGroup()
                        .addComponent(symbolSaveButton, javax.swing.GroupLayout.PREFERRED_SIZE, 164, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(72, 72, 72)
                        .addComponent(symbolClearButton, javax.swing.GroupLayout.PREFERRED_SIZE, 164, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(symbolRecordPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(symbolRecordPad, javax.swing.GroupLayout.PREFERRED_SIZE, 400, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 72, Short.MAX_VALUE)
                .addGroup(symbolRecordPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 164, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(symbolPurposeSelector, javax.swing.GroupLayout.PREFERRED_SIZE, 164, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(symbolRecordPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jLabel2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 282, Short.MAX_VALUE)
                        .addComponent(jLabel4, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 164, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(symbolNameSelector, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 164, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 164, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(98, Short.MAX_VALUE))
        );
        symbolRecordPanelLayout.setVerticalGroup(
            symbolRecordPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(symbolRecordPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(symbolRecordPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(symbolRecordPanelLayout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(symbolNameSelector, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jLabel4)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(symbolPurposeSelector, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(32, 32, 32)
                        .addComponent(jButton1)
                        .addGap(86, 86, 86)
                        .addComponent(jLabel2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 119, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(symbolRecordPanelLayout.createSequentialGroup()
                        .addComponent(jLabel3)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(symbolRecordPad, javax.swing.GroupLayout.PREFERRED_SIZE, 400, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(symbolRecordPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(symbolSaveButton)
                    .addComponent(symbolClearButton))
                .addContainerGap(43, Short.MAX_VALUE))
        );

        symbolTabManager.addTab("Record", symbolRecordPanel);

        javax.swing.GroupLayout symbolBrowsePanelLayout = new javax.swing.GroupLayout(symbolBrowsePanel);
        symbolBrowsePanel.setLayout(symbolBrowsePanelLayout);
        symbolBrowsePanelLayout.setHorizontalGroup(
            symbolBrowsePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 864, Short.MAX_VALUE)
        );
        symbolBrowsePanelLayout.setVerticalGroup(
            symbolBrowsePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 519, Short.MAX_VALUE)
        );

        symbolTabManager.addTab("Browse", symbolBrowsePanel);

        jLabel5.setFont(new java.awt.Font("DejaVu Sans", 1, 12)); // NOI18N
        jLabel5.setText("Draw symbol here");

        symbolRecognizePad.setBackground(new java.awt.Color(249, 247, 244));
        symbolRecognizePad.setName("symbolPad"); // NOI18N

        symbolTestButton.setText("Test");
        symbolTestButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                symbolTestButtonMouseClicked(evt);
            }
        });

        symbolClearTestButton.setText("Clear");
        symbolClearTestButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                symbolClearTestButtonMouseClicked(evt);
            }
        });

        jLabel6.setFont(new java.awt.Font("DejaVu Sans", 1, 12)); // NOI18N
        jLabel6.setForeground(new java.awt.Color(195, 106, 10));
        jLabel6.setText("Select HMM Transition Type");

        symbolHMMTransitionSelector.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "bakis", "ergodic" }));

        symbolRecognizedLabel.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        symbolRecognizedLabel.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Recognized Symbol", javax.swing.border.TitledBorder.CENTER, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("DejaVu Sans", 1, 12), new java.awt.Color(195, 106, 10))); // NOI18N
        symbolRecognizedLabel.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);

        jLabel8.setFont(new java.awt.Font("DejaVu Sans", 1, 12)); // NOI18N
        jLabel8.setForeground(new java.awt.Color(195, 106, 10));
        jLabel8.setText("Observations");

        symbolRecognizeObsText.setEditable(false);
        symbolRecognizeObsText.setColumns(20);
        symbolRecognizeObsText.setRows(5);
        jScrollPane2.setViewportView(symbolRecognizeObsText);

        javax.swing.GroupLayout symbolRecognizePanelLayout = new javax.swing.GroupLayout(symbolRecognizePanel);
        symbolRecognizePanel.setLayout(symbolRecognizePanelLayout);
        symbolRecognizePanelLayout.setHorizontalGroup(
            symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(symbolRecognizePanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(symbolRecognizePad, javax.swing.GroupLayout.PREFERRED_SIZE, 400, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 148, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGroup(symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(symbolRecognizePanelLayout.createSequentialGroup()
                        .addGap(55, 55, 55)
                        .addGroup(symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(symbolRecognizePanelLayout.createSequentialGroup()
                                .addComponent(symbolTestButton, javax.swing.GroupLayout.PREFERRED_SIZE, 125, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(38, 38, 38)
                                .addComponent(symbolClearTestButton, javax.swing.GroupLayout.PREFERRED_SIZE, 125, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addComponent(jLabel6)
                            .addComponent(symbolHMMTransitionSelector, javax.swing.GroupLayout.PREFERRED_SIZE, 196, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(symbolRecognizedLabel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, symbolRecognizePanelLayout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 288, Short.MAX_VALUE)
                            .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                .addContainerGap(109, Short.MAX_VALUE))
        );
        symbolRecognizePanelLayout.setVerticalGroup(
            symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(symbolRecognizePanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel5)
                    .addComponent(jLabel6))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, symbolRecognizePanelLayout.createSequentialGroup()
                        .addComponent(symbolHMMTransitionSelector, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(58, 58, 58)
                        .addGroup(symbolRecognizePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(symbolClearTestButton)
                            .addComponent(symbolTestButton))
                        .addGap(44, 44, 44)
                        .addComponent(symbolRecognizedLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 54, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(32, 32, 32)
                        .addComponent(jLabel8)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 135, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(symbolRecognizePad, javax.swing.GroupLayout.PREFERRED_SIZE, 400, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(82, Short.MAX_VALUE))
        );

        symbolTabManager.addTab("Recognize", symbolRecognizePanel);

        jMenu1.setText("File");
        jMenuBar1.add(jMenu1);

        jMenu2.setText("Edit");
        jMenuBar1.add(jMenu2);

        setJMenuBar(jMenuBar1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(35, 35, 35)
                .addComponent(symbolTabManager, javax.swing.GroupLayout.PREFERRED_SIZE, 800, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(symbolTabManager, javax.swing.GroupLayout.Alignment.TRAILING)
        );

        symbolTabManager.getAccessibleContext().setAccessibleName("symbolTabbedPane");

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void symbolSaveButtonMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_symbolSaveButtonMouseClicked
        // get the symbol from the symbolPad
        List<SymbolPoint> currentSymbol = symbolRecordPad.getCurrentSymbol();
        if (currentSymbol != null) {
            // get the symbol name from the selector
            String symbolName = (String)symbolNameSelector.getSelectedItem();
            String symbolPurpose = (String)symbolPurposeSelector.getSelectedItem();
            
            List<List<SymbolPoint>> symbolInstances = symbolTrackerMap.get(symbolName).get(symbolPurpose);
            symbolInstances.add(currentSymbol);
            
            String obsText = "Saved " + symbolPurpose.toUpperCase() + " instance "
                           + "of symbol " + symbolName.toUpperCase() + ".\n";
            obsText += "We now have " + symbolInstances.size() + " instances.";
            
            symbolObservationText.setText(obsText);
            symbolRecordPad.clearSymbol();
        }
    }//GEN-LAST:event_symbolSaveButtonMouseClicked

    private void symbolClearButtonMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_symbolClearButtonMouseClicked
        // clear symbol pad and observation text
        symbolRecordPad.clearSymbol();
        symbolObservationText.setText(null);
    }//GEN-LAST:event_symbolClearButtonMouseClicked

    private void symbolClearTestButtonMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_symbolClearTestButtonMouseClicked
        symbolRecognizePad.clearSymbol();
        symbolRecognizeObsText.setText(null);
        symbolRecognizedLabel.setText(null);
    }//GEN-LAST:event_symbolClearTestButtonMouseClicked

    private void symbolTestButtonMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_symbolTestButtonMouseClicked
        // get the symbol from the symbolPad
        List<SymbolPoint> currentSymbol = symbolRecognizePad.getCurrentSymbol();
        if (currentSymbol != null) {
            // get the selected transition model choice
            String hmmTransitionModel = (String)symbolHMMTransitionSelector.getSelectedItem();
            
            // call the matlab runtime
            //SymbolTesting symbolTester = null;
            CallbackInterface callbackInterface = null;
            MWCharArray widgetName = null;
            MWCharArray eventType = null;
            MWNumericArray trackData = null;
            Object[] result = null;
            
            
            try {
                //symbolTester = new SymbolTesting();
                callbackInterface = new CallbackInterface();
                
                int[] dims = {currentSymbol.size(), 3};
                trackData = MWNumericArray.newInstance(dims, MWClassID.DOUBLE, MWComplexity.REAL);
                
                int[] index = new int[2];
                for (int i = 0; i < currentSymbol.size(); i++) {
                    index[0] = (i + 1);
                    index[1] = 1;
                    trackData.set(index, currentSymbol.get(i).getX());
                    
                    index[0] = (i + 1);
                    index[1] = 2;
                    trackData.set(index, currentSymbol.get(i).getY());
                    
                    index[0] = (i + 1);
                    index[1] = 3;
                    trackData.set(index, currentSymbol.get(i).getTime());
                }
                
                widgetName = new MWCharArray("symbolTestButton");
                eventType = new MWCharArray("mouseClick");
                
                result = callbackInterface.gui_interfacing(4, widgetName, eventType, trackData, hmmTransitionModel);
                System.out.println(result);
                
                /*
                result = symbolTester.symbol_recognize(2, trackData, hmmTransitionModel);
                String recognizedSymbol = result[0].toString();
                double[] llVector = ((MWNumericArray)result[1]).getDoubleData();
                
                // do graphic output
                symbolRecognizedLabel.setText(recognizedSymbol);
                
                String obsText = "";
                for (int s = 0; s < symbolNameSelector.getItemCount(); s++) {
                    String symbolName = (String)symbolNameSelector.getItemAt(s);
                    obsText +=  "Likelihoold for " + symbolName.toUpperCase() + 
                                " = " + new DecimalFormat("#.####").format(llVector[s]) + "\n";
                }
                symbolRecognizeObsText.setText(obsText);
                */
                
                
            } catch (MWException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            } finally {
                if (trackData != null) MWArray.disposeArray(trackData);
                if (result != null && result[1] != null) MWArray.disposeArray(result[1]);
                
                if (widgetName != null) MWArray.disposeArray(widgetName);
                if (eventType != null) MWArray.disposeArray(eventType);
                
                //if (symbolTester != null) symbolTester.dispose();
                if (callbackInterface != null) callbackInterface.dispose();
            }
        }
    }//GEN-LAST:event_symbolTestButtonMouseClicked
  
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(SymbolRecognition.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(SymbolRecognition.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(SymbolRecognition.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(SymbolRecognition.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new SymbolRecognition().setVisible(true);
            }
        });
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenu jMenu2;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JPanel symbolBrowsePanel;
    private javax.swing.JButton symbolClearButton;
    private javax.swing.JButton symbolClearTestButton;
    private javax.swing.JComboBox symbolHMMTransitionSelector;
    private javax.swing.JComboBox symbolNameSelector;
    private javax.swing.JTextArea symbolObservationText;
    private javax.swing.JComboBox symbolPurposeSelector;
    private javax.swing.JTextArea symbolRecognizeObsText;
    private org.aria.edu.symrec.gui.SymbolCanvas symbolRecognizePad;
    private javax.swing.JPanel symbolRecognizePanel;
    private javax.swing.JLabel symbolRecognizedLabel;
    private org.aria.edu.symrec.gui.SymbolCanvas symbolRecordPad;
    private javax.swing.JPanel symbolRecordPanel;
    private javax.swing.JButton symbolSaveButton;
    private javax.swing.JTabbedPane symbolTabManager;
    private javax.swing.JButton symbolTestButton;
    // End of variables declaration//GEN-END:variables

    private Map<String, Map<String, List<List<SymbolPoint>>>> symbolTrackerMap;
}
