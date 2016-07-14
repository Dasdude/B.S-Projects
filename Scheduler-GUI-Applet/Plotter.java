import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Graphics;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.LinkedList;

import javax.swing.BoxLayout;
import javax.swing.JApplet;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.JTextPane;



public class Plotter extends JApplet {
	int lineDistance;
	int appletHeight;
	int appletWidth;
	int boxHeight;
	int pixelPerTime;
	int timeZeroPixelPlacement;
	int timeSpan;
	int textMargin;
	int schedulingMethod; 
	int timePerTick;
	int clickDebugger=0;
	int page;// 1: input jobs and parameter  2: show plot 
	LinkedList<JobType> type ;
	JobProducer jobPro ;
	static Color[] CIDColor={Color.lightGray,Color.DARK_GRAY,Color.black,Color.yellow,Color.GREEN,Color.black}; ;
	Graphics gr;
	Graphics or;
	LinkedList<int[]> boxes;
	LinkedList<int[]> arrivalTimes;
	private int topMargin;
	
	// input GUI
	JLabel inputSize;
	JButton AddJobButton;
	
	public  JPanel jPanel1;
	public  JPanel jPanel2;
	public  JTextPane jTextPane2;
	public  JTextField jTextFieldInitial;
	public  JTextPane jTextPane4;
	public  JTextField jTextFieldExecute;
	public  JTextPane jTextPane1;
	public  JTextField jTextField1;
	public	  JTextPane jTextPane3;
	public JTextField jTextFieldDeadline;
	public JButton jButton1;
	public	  JButton jButtonStartScheduling;
	public	  JTextPane jTextPaneSchedMethod;
	public	  JTextField jTextFieldTimeSpan;
	public	  JTextPane jTextPaneTimespan;
	public	  JTextField jTextFieldSchedMethod;
	public	  JTextPane jTextPaneTimePerTick;
	public	  JTextField jTextFieldTimePerTick;
	
	
	@Override
	public void init() {
		// TODO Auto-generated method stub
		super.init();
		schedulingMethod =3;			// 1 : Rate Monotonic  2: deadline Monotonic  3 : EDF
		type = new LinkedList<JobType>();
		timePerTick=500;               // Customize your time per tick to edit Demonstration Time  
		page=1;
	    
		appletHeight= 600;
		appletWidth =1500;
		lineDistance= 100;
		timeSpan = 30;
		timeZeroPixelPlacement=300;
		
		topMargin=30;
		boxHeight=50;
		textMargin = 10;
		this.setSize(appletWidth, appletHeight);
		this.setBackground(Color.white);
		boxes = new LinkedList<int[]>();
		arrivalTimes = new LinkedList<int[]>();
		jobPro = new JobProducer(timeSpan,type,schedulingMethod,this);
		jButton1 = new JButton();
		jButtonStartScheduling = new JButton();
		jTextField1 = new JTextField();
		jTextFieldSchedMethod = new JTextField();
		jTextFieldDeadline = new JTextField();
		jTextFieldInitial = new JTextField();
		jTextFieldExecute = new JTextField();
		jTextFieldTimePerTick = new JTextField();
		jTextFieldTimeSpan = new JTextField();
		jTextPane1 = new JTextPane();
		jTextPane2 = new JTextPane();
		jTextPane3 = new JTextPane();
		jTextPane4 = new JTextPane();
		jTextPaneSchedMethod = new JTextPane();
		jTextPaneTimePerTick = new JTextPane();
		jTextPaneTimespan = new JTextPane();
	}

	
	@Override

public void paint(Graphics gr) {
	// TODO Auto-generated method stub
		
	super.paint(gr);
	gr.setColor(Color.black);
	switch (page) {
	case 1:
			hell(gr);
		break;
	case 2:
			
			showSchedulerPlotterPage(gr);
		break;

	default:
		break;
	}
	
}
	void hell(Graphics gr)
	{
		if(page==1)
		{
			
		try {
			{
				getContentPane().setLayout(null);
			}
			getContentPane().setLayout(null);
			setSize(new Dimension(appletWidth,appletHeight));
			{
				jPanel1 = new JPanel();
				getContentPane().add(jPanel1);
				jPanel1.setBounds(469, 219, 10, 10);
			}
			{
				jPanel2 = new JPanel();
				BoxLayout jPanel2Layout = new BoxLayout(jPanel2, javax.swing.BoxLayout.Y_AXIS);
				jPanel2.setLayout(jPanel2Layout);
				getContentPane().add(jPanel2);
				jPanel2.setBounds(0, 0, 600, 400);
				
				{
					jPanel2.add(jTextPane2);
					jTextPane2.setText("Initial Arrival");
					jTextPane2.setEditable(false);
				}
				{
					jPanel2.add(jTextFieldInitial);
				}
				{
					jPanel2.add(jTextPane4);
					jTextPane4.setText("Execution Time");
					jTextPane4.setEditable(false);
				}
				{
					jPanel2.add(jTextFieldExecute);
				}
				{
					jPanel2.add(jTextPane1);
					jTextPane1.setText("Period");
					jTextPane1.setEditable(false);
				}
				{
					jPanel2.add(jTextField1);
					
				}
				{
					jPanel2.add(jTextPane3);
					jTextPane3.setText("Relative Deadline");
					jTextPane3.setEditable(false);
				}
				{
					jPanel2.add(jTextFieldDeadline);
				}
				{
					jPanel2.add(jTextPaneTimespan);
					jTextPaneTimespan.setText("Time Range");
					jTextPaneTimespan.setEditable(false);
				}
				{
					jPanel2.add(jTextFieldTimeSpan);
				}
				{
					jPanel2.add(jTextPaneSchedMethod);
					jTextPaneSchedMethod.setText("Scheduling Method : rm:1  dm :2  EDF :3");
					jTextPaneSchedMethod.setEditable(false);
				}
				{
					jPanel2.add(jTextFieldSchedMethod);
				}
				{
					jPanel2.add(jTextPaneTimePerTick);
					jTextPaneTimePerTick.setText("Specify your time unit for illustration(ns)");
					jTextPaneTimePerTick.setEditable(false);
				}
				{
					jPanel2.add(jTextFieldTimePerTick);
				}
				
				{
					jPanel2.add(jButton1);
					jButton1.setText("Add Job");
					jButton1.addMouseListener(new MouseAdapter() {
						@Override
						public void mouseClicked(MouseEvent evt) {
							
							jButton1MouseClicked(evt);
						}
						
					});
				}
				
				{
					jPanel2.add(jButtonStartScheduling);
					jButtonStartScheduling.setText("Start Scheduling");
					jButtonStartScheduling.setPreferredSize(new java.awt.Dimension(248, 23));
					jButtonStartScheduling.addMouseListener(new MouseAdapter() {
						@Override
						public void mouseClicked(MouseEvent evt) {
							jButtonStartSchedulingMouseClicked(evt);
						}
//						@Override
//						public void mouseReleased(MouseEvent evt) {
//							jButtonStartSchedulingMouseClicked(evt);
//						}
					});
				}
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}}
	}
protected void jButton1MouseClicked(MouseEvent evt) {
		// TODO Auto-generated method stub
	if(1-clickDebugger==1)
	{
		String pers = jTextField1.getText();
		String execs = jTextFieldExecute.getText();
		String deads = jTextFieldDeadline.getText();
		String arrivs = jTextFieldInitial.getText();
		int exec = Integer.parseInt(execs);
		int dead = Integer.parseInt(deads);
		int arriv = Integer.parseInt(arrivs);
		int per = Integer.parseInt(pers);
		System.out.println(per);
		System.out.println(exec);
		JobType a = new JobType(per,arriv,exec,dead);
		System.out.println(type.size());
		type.add(a);
		System.out.println(type.size());
		
	}
	clickDebugger = 1- clickDebugger;
	}


protected void jButtonStartSchedulingMouseClicked(MouseEvent evt) {
		// TODO Auto-generated method stub
		getContentPane().removeAll();
		this.schedulingMethod=Integer.parseInt(jTextFieldSchedMethod.getText());
		this.timePerTick=Integer.parseInt(jTextFieldTimePerTick.getText());
		this.timeSpan=Integer.parseInt(jTextFieldTimeSpan.getText());
		pixelPerTime=(appletWidth-timeZeroPixelPlacement-10)/timeSpan;
		jobPro.jobProducerRun();
		page=2;
		repaint();
	}



void showSchedulerPlotterPage(Graphics gr)
{
	
	drawAxes(gr);
	if(!arrivalTimes.isEmpty())
	{
		for(int i =0;i<arrivalTimes.size();i++)
		{		
			gr.setColor(Color.red);
			gr.fill3DRect(timeZeroPixelPlacement+arrivalTimes.get(i)[0]*pixelPerTime-2,topMargin+lineDistance*(arrivalTimes.get(i)[1]+1)-boxHeight, 4, boxHeight, true);
		}
	}
	if(!boxes.isEmpty())
	{
		for(int i =0;i<boxes.size();i++)
		{		
			gr.setColor(Color.DARK_GRAY);
			gr.fill3DRect(boxes.get(i)[0], boxes.get(i)[1], pixelPerTime, boxHeight, true);
			gr.setColor(Color.white);
			Font a = new Font(null,Font.BOLD,10);
			gr.setFont(a);
			gr.drawString("PID:"+boxes.get(i)[3],(boxes.get(i)[0]+pixelPerTime/2)-10, boxes.get(i)[1]+boxHeight/2);
			try {
				Thread.sleep(timePerTick);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		this.destroy();
	}
}
void DrawBox(int time, int CID , int ICPID)
{
	
	this.getGraphics().setColor(CIDColor[CID]);
//	this.gr.fill3DRect(timeZeroPixelPlacement+time*pixelPerTime, topMargin+lineDistance*(CID+1)-boxHeight, pixelPerTime, boxHeight, true);
	int[] a = {timeZeroPixelPlacement+time*pixelPerTime, topMargin+lineDistance*(CID+1)-boxHeight,CID,ICPID};
	boxes.add(a);
	
}
void drawAxes(Graphics gr )
{
	gr.drawLine(0,topMargin, timeZeroPixelPlacement+(pixelPerTime*timeSpan), topMargin);
	
	for(int i =1 ; i<=type.size();i++)
	{
		//x Horizontal Line
		gr.drawLine(0,topMargin+lineDistance*i, timeZeroPixelPlacement+(pixelPerTime*timeSpan), topMargin+lineDistance*i);
		// Legend Text
		gr.drawString("Job ID : "+ (i-1) ,textMargin, 20+topMargin+lineDistance*(i-1));
		gr.drawString("Period : " + type.get(i-1).period,textMargin, 40+topMargin+lineDistance*(i-1));
		gr.drawString("Initial Arrival : " + type.get(i-1).initialArrival,textMargin, 60+topMargin+lineDistance*(i-1));
		gr.drawString("Relative Deadline : " + type.get(i-1).reletiveDeadline,textMargin, 80+topMargin+lineDistance*(i-1));
		gr.drawString("Execution Time : " + type.get(i-1).executionTime,(timeZeroPixelPlacement/2)+textMargin, 60+topMargin+lineDistance*(i-1));
		switch (schedulingMethod){
		case 1:
			gr.drawString("Scheduling Method : Rate Monotonic",textMargin, topMargin/2);
			break;
		case 2:
			gr.drawString("Scheduling Method : Deadline Monotonic",textMargin, topMargin/2);
			break;
		case 3:
			gr.drawString("Scheduling Method : Earliest Deadline First",textMargin, topMargin/2);
			break;
		}
		for(int j = 1; j<=timeSpan;j++)
		{
			gr.drawLine(timeZeroPixelPlacement+(pixelPerTime*j),topMargin+lineDistance*i+3 , timeZeroPixelPlacement+(pixelPerTime*j), topMargin+lineDistance*i-3);
			char[] q = Integer.toString(j).toCharArray();
			gr.drawChars(q, 0, q.length, timeZeroPixelPlacement+j*pixelPerTime-4, topMargin+lineDistance*i+20);
		}
	}
	// y vertical line
	gr.drawLine(timeZeroPixelPlacement+(pixelPerTime*timeSpan), topMargin, timeZeroPixelPlacement+(pixelPerTime*timeSpan), topMargin+lineDistance*type.size());
	gr.drawLine(timeZeroPixelPlacement, topMargin, timeZeroPixelPlacement, topMargin+lineDistance*type.size());
	
	//Legend draw
	gr.drawLine(timeZeroPixelPlacement, topMargin, timeZeroPixelPlacement, topMargin+lineDistance*type.size());
	gr.drawLine(0, topMargin, 0, topMargin+lineDistance*type.size());
}


	
	
	
}




