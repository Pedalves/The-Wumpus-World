using System;
using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using SbsSW.SwiPlCs;

public class GM : MonoBehaviour
{
    public GameObject GameOverText;
    public Text PointsText;
    public Text ConsoleText;

    [SerializeField]
    private bool _gameRunning;
    private Agent _agent;

    static private GM _instance;

    private void Awake()
    {
        if(_instance)
        {
            Destroy(gameObject);
        }
        else
        {
            _instance = this;

            Environment.SetEnvironmentVariable("SWI_HOME_DIR", @"C:\Program Files (x86)\swipl");
            Environment.SetEnvironmentVariable("Path", Environment.GetEnvironmentVariable("Path") + @";C:\Program Files (x86)\swipl;C:\Program Files (x86)\swipl\bin");
            if (!PlEngine.IsInitialized)
            {
                Debug.Log("entrou");
                String[] param = { "-q" };  // suppressing informational and banner messages
                PlEngine.Initialize(param);
                PlQuery.PlCall("assert(father(martin, inka))");
                PlQuery.PlCall("assert(father(uwe, gloria))");
                PlQuery.PlCall("assert(father(uwe, melanie))");
                PlQuery.PlCall("assert(father(uwe, ayala))");
                using (var q = new PlQuery("father(P, C), atomic_list_concat([P,' is_father_of ',C], L)"))
                {
                    foreach (PlQueryVariables v in q.SolutionVariables)
                    {
                        Debug.Log(v["L"].ToString());
                        ConsoleText.text += v["L"].ToString() + "\n";
                    }

                    Debug.Log("all children from uwe:");
                    ConsoleText.text += "all children from uwe:" + "\n";
                    q.Variables["P"].Unify("uwe");
                    foreach (PlQueryVariables v in q.SolutionVariables)
                    {
                        Debug.Log(v["C"].ToString());
                        ConsoleText.text += v["C"].ToString() + "\n";
                    }
                }
                PlEngine.PlCleanup();
                Debug.Log("finshed!");
            }
        }
    }

    // Use this for initialization
    void Start ()
    {
        _gameRunning = true;	
	}

    private void Update()
    {
        PointsText.text = "Points: " + GetAgent().Points;
    }

    static public GM GetInstance()
    {
        return _instance;
    }

    public Agent GetAgent()
    {
        if(!_agent)
        {
            _agent = GameObject.FindGameObjectWithTag("Agent").GetComponent<Agent>();
        }
        return _agent;
    }

    public bool GetGameRunning()
    {
        return _gameRunning;
    }

    public void SetGameRunning(bool running)
    {
        _gameRunning = running;

        if(!running)
        {
            GameOverText.SetActive(true);
            GameOverText.GetComponent<Text>().text = "Game Over\nPoints: " + GetAgent().Points;
            StartCoroutine(GetInstance().Restart());
        }
    }

    IEnumerator Restart()
    {
        yield return new WaitForSeconds(3);
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    public void UpdatePoints(int points)
    {
        PointsText.text = "Points: " + points;
    }
}
