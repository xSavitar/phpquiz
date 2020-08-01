<?php declare(strict_types=1);

namespace App\Controller;

use App\Entity\Question;
use App\Repository\QuestionRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class QuestionController extends AbstractController
{
    private QuestionRepository $questionRepository;

    public function __construct(QuestionRepository $questionRepository)
    {
        $this->questionRepository = $questionRepository;
    }

    /**
     * @Route("/", name="home")
     */
    public function show(): Response
    {
        $question = $this->questionRepository->find(1);
        if (!$question instanceof Question) {
            throw $this->createNotFoundException('Question not found');
        }

        return $this->render('answer/show.html.twig', compact('question'));
    }
}