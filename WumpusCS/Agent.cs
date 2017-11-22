using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WumpusCS
{
    class Agent
    {
        public enum Direction
        {
            Up,
            Down,
            Left,
            Right
        }

        public int X { get; set; }
        public int Y { get; set; }
        private Direction _direction;
        private Map _map;

        public Agent(Map map)
        {
            X = 0;
            Y = 0;
            _direction = Direction.Up;
            _map = map;
        }

        public void NewAction(String action)
        {
            switch (action)
            {
                case "move":
                    Move();
                    break;
                case "turnRight":
                    TurnRight();
                    break;
                case "turnLeft":
                    TurnLeft();
                    break;
                case "grab":
                    Grab();
                    break;
                case "scream":
                    Scream();
                    break;
                default:
                    break;
            }
        }

        private void Scream()
        {
            
        }

        private void Grab()
        {
            for(int i = 0; i < 3 ;i++)
            {
                if(_map.Gold[i, 0] == X / 30 && _map.Gold[i, 1] == Y / 30)
                {
                    _map.Gold[i, 0] = -1;
                    _map.Gold[i, 1] = -1;
                }
            } 
        }

        private void Move()
        {
            switch (_direction)
            {
                case Direction.Up:
                    Y += 30;
                    break;
                case Direction.Down:
                    Y -= 30;
                    break;
                case Direction.Left:
                    X -= 30;
                    break;
                case Direction.Right:
                    X += 30;
                    break;
                default:
                    break;
            }
        }

        void TurnRight()
        {
            switch (_direction)
            {
                case Direction.Up:
                    _direction = Direction.Right;
                    break;
                case Direction.Down:
                    _direction = Direction.Left;
                    break;
                case Direction.Left:
                    _direction = Direction.Up;
                    break;
                case Direction.Right:
                    _direction = Direction.Down;
                    break;
                default:
                    break;
            }
        }

        void TurnLeft()
        {
            switch (_direction)
            {
                case Direction.Up:
                    _direction = Direction.Left;
                    break;
                case Direction.Down:
                    _direction = Direction.Right;
                    break;
                case Direction.Left:
                    _direction = Direction.Down;
                    break;
                case Direction.Right:
                    _direction = Direction.Up;
                    break;
                default:
                    break;
            }
        }
    }
}
