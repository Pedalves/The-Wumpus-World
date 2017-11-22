using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WumpusCS
{
    class Map
    {
        public int[,] Gold { get; set; }
        public int[,] Pit { get; set; }

        public int[,] Wumpus50 { get; set; }
        public int[,] Wumpus20 { get; set; }


        public Map(bool random = true)
        {
            Gold = new int[3, 2];
            Pit = new int[8, 2];
            Wumpus50 = new int[2, 2];
            Wumpus20 = new int[2, 2];

            if (random)
            {
                Random rnd = new Random();

                // pit
                for (int i = 0; i < 8 ; i++)
                {
                    bool running = true;

                    int x = -1;
                    int y = -1;

                    while (running)
                    {
                        x = rnd.Next(0, 12);
                        y = rnd.Next(0, 12);

                        bool newValue = true;

                        if (x == 0 && y == 0)
                        {
                            newValue = false;
                        }

                        for (int j = i; j >= 0; j--)
                        {
                            if (i != j)
                            {
                                if (x == Pit[j, 0] && y == Pit[j, 1])
                                {
                                    newValue = false;
                                }
                            }

                        }

                        running = !newValue;
                    }

                    Pit[i, 0] = x;
                    Pit[i, 1] = y;
                }

                // gold
                for (int i = 0; i < 3; i++)
                {
                    bool running = true;

                    int x = -1;
                    int y = -1;

                    while (running)
                    {
                        x = rnd.Next(0, 12);
                        y = rnd.Next(0, 12);

                        bool newValue = true;

                        if (x == 0 && y == 0)
                        {
                            newValue = false;
                        }

                        for (int j = i; j >= 0; j--)
                        {
                            if (i != j)
                            {
                                if (x == Gold[j, 0] && y == Gold[j, 1])
                                {
                                    newValue = false;
                                }
                            }
                        }

                        for (int j = 0; j < 8; j++)
                        {
                            if (x == Pit[j, 0] && y == Pit[j, 1])
                            {
                                newValue = false;
                            }
                        }

                        running = !newValue;
                    }

                    Gold[i, 0] = x;
                    Gold[i, 1] = y;
                }

                // wumpus20
                for (int i = 0; i < 2; i++)
                {
                    bool running = true;

                    int x = -1;
                    int y = -1;

                    while (running)
                    {
                        x = rnd.Next(0, 12);
                        y = rnd.Next(0, 12);

                        bool newValue = true;

                        if (x == 0 && y == 0)
                        {
                            newValue = false;
                        }

                        for (int j = i; j >= 0; j--)
                        {
                            if (i != j)
                            {
                                if (x == Wumpus20[j, 0] && y == Wumpus20[j, 1])
                                {
                                    newValue = false;
                                }
                            }
                        }

                        for (int j = 0; j < 8; j++)
                        {
                            if (x == Pit[j, 0] && y == Pit[j, 1])
                            {
                                newValue = false;
                            }
                        }

                        for (int j = 0; j < 3; j++)
                        {
                            if (x == Gold[j, 0] && y == Gold[j, 1])
                            {
                                newValue = false;
                            }
                        }

                        running = !newValue;
                    }

                    Wumpus20[i, 0] = x;
                    Wumpus20[i, 1] = y;
                }

                // wumpus50
                for (int i = 0; i < 2; i++)
                {
                    bool running = true;

                    int x = -1;
                    int y = -1;

                    while (running)
                    {
                        x = rnd.Next(0, 12);
                        y = rnd.Next(0, 12);

                        bool newValue = true;

                        if (x == 0 && y == 0)
                        {
                            newValue = false;
                        }

                        for (int j = i; j >= 0; j--)
                        {
                            if (i != j)
                            {
                                if (x == Wumpus50[j, 0] && y == Wumpus50[j, 1])
                                {
                                    newValue = false;
                                }
                            }
                        }

                        for (int j = 0; j < 8; j++)
                        {
                            if (x == Pit[j, 0] && y == Pit[j, 1])
                            {
                                newValue = false;
                            }
                        }

                        for (int j = 0; j < 3; j++)
                        {
                            if (x == Gold[j, 0] && y == Gold[j, 1])
                            {
                                newValue = false;
                            }
                        }

                        for (int j = 0; j < 2; j++)
                        {
                            if (x == Wumpus20[j, 0] && y == Wumpus20[j, 1])
                            {
                                newValue = false;
                            }
                        }

                        running = !newValue;
                    }

                    Wumpus50[i, 0] = x;
                    Wumpus50[i, 1] = y;
                }
            }
            else
            {
                Pit[0, 0] = 0;
                Pit[0, 1] = 2;

                Pit[1, 0] = 7;
                Pit[1, 1] = 1;

                Pit[2, 0] = 5;
                Pit[2, 1] = 1;

                Pit[3, 0] = 9;
                Pit[3, 1] = 9;

                Pit[4, 0] = 3;
                Pit[4, 1] = 3;

                Pit[5, 0] = 2;
                Pit[5, 1] = 1;

                Pit[6, 0] = 0;
                Pit[6, 1] = 7;

                Pit[7, 0] = 2;
                Pit[7, 1] = 8;

                Gold[0, 0] = 5;
                Gold[0, 1] = 5;

                Gold[1, 0] = 1;
                Gold[1, 1] = 1;

                Gold[2, 0] = 8;
                Gold[2, 1] = 1;

                Wumpus20[0, 0] = 3;
                Wumpus20[0, 1] = 1;

                Wumpus20[1, 0] = 11;
                Wumpus20[1, 1] = 10;

                Wumpus50[0, 0] = 4;
                Wumpus50[0, 1] = 3;

                Wumpus50[1, 0] = 11;
                Wumpus50[1, 1] = 1;
            }
        }
    }
}
