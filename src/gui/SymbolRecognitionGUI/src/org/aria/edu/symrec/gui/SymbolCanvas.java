/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.aria.edu.symrec.gui;

import java.awt.Canvas;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import javax.swing.JTextArea;

/**
 *
 * @author alex
 */
public class SymbolCanvas extends Canvas {
    
    private static final int NR_POINTS = 64;
    private List<SymbolPoint> currentSymbol;
    
    private boolean trackingActive = false;
    private int currentX;
    private int currentY;
    
    private JTextArea obsTextArea;
    
    public SymbolCanvas() {
        addMouseListener(new MyMouseListener());
        addMouseMotionListener(new MyMouseListener());
    }
    
    public void setObsTextArea(JTextArea obsTextArea) {
        this.obsTextArea = obsTextArea;
    }
    
    @Override
    public void update(Graphics g) {
        paint(g);
    }
    
    @Override
    public void paint(Graphics g) {
        g.setColor(Color.red);
        g.drawChars(new char[] {'*'}, 0, 1, currentX, currentY);
        
        g.setColor(getBackground());
    }

    public List<SymbolPoint> getCurrentSymbol() {
        return currentSymbol;
    }
    
    public void clearSymbol() {
        if (currentSymbol != null) {
            currentSymbol.clear();
            currentSymbol = null;

            getGraphics().setColor(getBackground());
            getGraphics().clearRect(0, 0, getWidth(), getHeight());
        }
    }
    
    class MyMouseListener extends MouseAdapter {
        public void mousePressed(MouseEvent e) {
            if (e.getButton() == MouseEvent.BUTTON1) {
                trackingActive = true;
                currentSymbol = new ArrayList<SymbolPoint>();
            }
            else if (e.getButton() == MouseEvent.BUTTON3) {
                if (currentSymbol != null) {
                    currentSymbol.clear();
                    currentSymbol = null;
                
                    getGraphics().setColor(getBackground());
                    getGraphics().clearRect(0, 0, getWidth(), getHeight());
                }
            }
        }
        
        public void mouseReleased(MouseEvent e) {
            if (e.getButton() == MouseEvent.BUTTON1) {
                trackingActive = false;
                
                if (currentSymbol.size() >= NR_POINTS) {
                    bboxResize(getWidth(), getHeight());
                    
                    /*
                    System.out.println("## A " + currentSymbol.size() + " long symbol: ");
                    for (SymbolPoint p : currentSymbol) {
                        System.out.println("x = " + p.getX() + ", " + "y = " + p.getY() + 
                                            ", " + "t = " + p.getTime());
                    }
                    
                    System.out.println("");
                    */
                }
                else {
                    if (obsTextArea != null) {
                        obsTextArea.setText("Less than " + NR_POINTS + " sampled points.\n"
                                + "Move slower or draw longer shape!!!");
                    }
                }
            }
        }
        
        public void mouseDragged(MouseEvent e) {
            if (trackingActive) {
                currentX = e.getX();
                currentY = e.getY();
                long time = Calendar.getInstance().getTimeInMillis();
                
                int width = getWidth();
                int height = getHeight();
                
                double x = (double)currentX / (double)width;
                double y = (double)(height - currentY) / (double)height;
                
                currentSymbol.add(new SymbolPoint(x, y, time));
                repaint();
            }
        }

        private void bboxResize(double maxWidth, double maxHeight) {
            if (currentSymbol != null) {
                double xMax = 0;
                double xMin = maxWidth;
                
                double yMax = 0;
                double yMin = maxHeight;
                
                double initTime = currentSymbol.get(0).getTime();
                
                // determine bounds
                for (SymbolPoint p : currentSymbol) {
                    if (p.getX() > xMax) {
                        xMax = p.getX();
                    }
                    else if (p.getX() < xMin) {
                        xMin = p.getX();
                    }
                    
                    if (p.getY() > yMax) {
                        yMax = p.getY();
                    }
                    else if (p.getY() < yMin) {
                        yMin = p.getY();
                    }
                }
                
                // resize axes independently
                for (SymbolPoint p : currentSymbol) {
                    double x = p.getX();
                    p.setX( (x - xMin) / (xMax - xMin) );
                    
                    double y = p.getY();
                    p.setY( (y - yMin) / (yMax - yMin) );
                    
                    double time = p.getTime();
                    p.setTime( (time - initTime) / 1000.0);   //store time in seconds with decimals
                }
            }
        }
    }
    
    class SymbolPoint {
        private double x;
        private double y;
        
        private double time;
        
        public SymbolPoint(double x, double y, double time) {
            this.x = x;
            this.y = y;
            this.time = time;
        }

        public double getX() {
            return x;
        }

        public double getY() {
            return y;
        }

        public double getTime() {
            return time;
        }

        public void setX(double x) {
            this.x = x;
        }

        public void setY(double y) {
            this.y = y;
        }

        public void setTime(double time) {
            this.time = time;
        }
        
    }
}
