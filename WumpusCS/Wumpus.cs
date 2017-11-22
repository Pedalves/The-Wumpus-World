using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using SbsSW.SwiPlCs;

namespace WumpusCS
{
    public partial class MainWindow : Form
    {
        private Agent _agent;
        private Map _map;

        public MainWindow()
        {
            InitializeComponent();
            Console.WriteLine("teste");

            Environment.SetEnvironmentVariable("SWI_HOME_DIR", @"C:\Program Files (x86)\swipl");
            Environment.SetEnvironmentVariable("Path", Environment.GetEnvironmentVariable("Path") + @";C:\Program Files (x86)\swipl;C:\Program Files (x86)\swipl\bin");
            if (!PlEngine.IsInitialized)
            {
                String[] param = { "-q" };
                PlEngine.Initialize(param);

                try
                {
                    PlQuery.PlCall("ensure_loaded('c:/users/pedro/PrologProjects/The-Wumpus-World/wumpus')");

                    SetupGame();

                    PlQuery.PlCall("start");
                }
                catch (SbsSW.SwiPlCs.Exceptions.PlException ex)
                {
                    Console.WriteLine("Exception handled: " + ex.Message);
                }
            }

            gameTimer.Start();
            gameTimer.Tick += GameLoop;
        }

        private void SetupGame()
        {
            _map = new Map();

            _agent = new Agent(_map);

            PlQuery.PlCall("retractall(pit_location(_))");
            PlQuery.PlCall("retractall(gold(_))");
            PlQuery.PlCall("retractall(wumpus20_location(_))");
            PlQuery.PlCall("retractall(wumpus50_location(_))");
            PlQuery.PlCall("retractall(wumpus20_health(_))");
            PlQuery.PlCall("retractall(wumpus50_health(_))");

            for(int i = 0; i < 8; i++)
                PlQuery.PlCall("assert(pit_location([" + _map.Pit[i, 0].ToString() + "," + _map.Pit[i, 1].ToString() + "]))");

            for (int i = 0; i < 3; i++)
                PlQuery.PlCall("assert(gold([" + _map.Gold[i, 0].ToString() + "," + _map.Gold[i, 1].ToString() + "]))");

            for (int i = 0; i < 2; i++)
            {
                PlQuery.PlCall("assert(wumpus20_location([" + _map.Wumpus20[i, 0].ToString() + "," + _map.Wumpus20[i, 1].ToString() + "]))");
                PlQuery.PlCall("assert(wumpus50_location([" + _map.Wumpus50[i, 0].ToString() + "," + _map.Wumpus50[i, 1].ToString() + "]))");

                PlQuery.PlCall("assert(wumpus20_health([100], [" + _map.Wumpus20[i, 0].ToString() + "," + _map.Wumpus20[i, 1].ToString() + "]))");
                PlQuery.PlCall("assert(wumpus50_health([100], [" + _map.Wumpus50[i, 0].ToString() + "," + _map.Wumpus50[i, 1].ToString() + "]))");
            }
        }

        private void GameLoop(object sender, EventArgs e)
        {
            PlQuery.PlCall("ready_next_action");

            string action = "";

            PlQuery actionQuery = new PlQuery("agent_next_action(Action)");

            foreach (PlQueryVariables s in actionQuery.SolutionVariables)
            {
                action = s["Action"].ToString();
            }

            actionQuery.Dispose();

            PlQuery.PlCall("execute_current_action");

            if(action == "shoot")
            {
                int tempX = _agent.X;
                int tempY = _agent.Y;

                _agent.Move();

                string health = "";

                PlQuery wumpus20Query = new PlQuery("wumpus20_health([Vida], [" + (_agent.X / 30).ToString() + "," + (_agent.Y / 30).ToString() + "])");

                foreach (PlQueryVariables s in wumpus20Query.SolutionVariables)
                {
                    health = s["Vida"].ToString();
                }

                wumpus20Query.Dispose();

                PlQuery wumpus50Query = new PlQuery("wumpus50_health([Vida], [" + (_agent.X / 30).ToString() + "," + (_agent.Y / 30).ToString() + "])");

                foreach (PlQueryVariables s in wumpus50Query.SolutionVariables)
                {
                    health = s["Vida"].ToString();
                }

                wumpus50Query.Dispose();

                try
                {
                    if (Int32.Parse(health) <= 0)
                    {
                        _agent.Kill();
                    }
                }
                catch
                {
                    _agent.Kill();
                }

                _agent.X = tempX;
                _agent.Y = tempY;
            }

            _agent.NewAction(action);

            mapView.Invalidate();
        }


        private void mapView_Paint(object sender, PaintEventArgs e)
        {
            Graphics canvas = e.Graphics;

            for (int i = 0; i <= 12; i++)
            {
                Pen pen = new Pen(Color.Black);
                canvas.DrawLine(pen, 30 * i, 0, 30 * i, 3600);
                canvas.DrawLine(pen, 0, 30 * i, 3600, 30 * i);
            }

            //Draw pit
            for (int i = 0; i < 8; i++)
            {
                canvas.FillRectangle(Brushes.Black, new Rectangle(_map.Pit[i, 0] * 30, 330 - _map.Pit[i, 1] * 30, 30, 30));
            }

            //Draw gold
            for (int i = 0; i < 3; i++)
            {
                canvas.FillRectangle(Brushes.Yellow, new Rectangle(_map.Gold[i, 0] * 30, 330 - _map.Gold[i, 1] * 30, 30, 30));
            }

            //Draw wumpus
            for (int i = 0; i < 2; i++)
            {
                canvas.FillEllipse(Brushes.Red, new Rectangle(_map.Wumpus20[i, 0] * 30, 330 - _map.Wumpus20[i, 1] * 30, 20, 20));
                canvas.FillEllipse(Brushes.Red, new Rectangle(_map.Wumpus50[i, 0] * 30, 330 - _map.Wumpus50[i, 1] * 30, 30, 30));
            }

            //Draw agent
            canvas.FillEllipse(Brushes.Green, new Rectangle(_agent.X, 330 - _agent.Y, 30, 30));
        }
    }
}
